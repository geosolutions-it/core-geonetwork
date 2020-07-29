/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */

package org.fao.geonet.api.csw;

import io.swagger.annotations.*;
import jeeves.server.JeevesEngine;
import org.fao.geonet.ApplicationContextHolder;
import org.fao.geonet.api.API;
import org.fao.geonet.api.exception.ResourceNotFoundException;
import org.fao.geonet.domain.Service;
import org.fao.geonet.domain.ServiceParam;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.kernel.schema.MetadataSchema;
import org.fao.geonet.repository.ServiceRepository;
import org.fao.geonet.repository.Updater;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Nonnull;
import java.io.File;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;

@RequestMapping(value = {
    "/{portal}/api/csw/virtuals",
    "/{portal}/api/" + API.VERSION_0_1 +
        "/csw/virtuals"
})
@Api(value = "csw",
    tags = "csw",
    description = "Virtual CSW operations")
@Controller("cswVirtual")
public class VirtualCswApi {

    public static final String API_PARAM_CSW_SERVICE_IDENTIFIER = "Service identifier";
    public static final String API_PARAM_CSW_SERVICE_DETAILS = "Service details";

    @Autowired
    private ServiceRepository serviceRepository;

    @Autowired
    private SchemaManager schemaManager;


    @ApiOperation(
        value = "Get virtual CSW services",
        notes = "Virtual CSWs are created to easily setup services " +
            "providing access to records without the need to define filters. For example, " +
            "in Europe, local, regional and national organizations define entry point " +
            "for records in the scope of the INSPIRE directive. Those services can then be " +
            "easily harvested to exchange information. " +
            "Virtual CSWs do not support transaction. For this use the main " +
            "catalog CSW service.",
        nickname = "getAllVirtualCsw")
    @RequestMapping(
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.GET)
    @ResponseStatus(value = HttpStatus.OK)
    @ResponseBody
    public List<Service> getAllVirtualCsw() throws Exception {
        return serviceRepository.findAll();
    }

    @ApiOperation(
        value = "Get a virtual CSW",
        notes = "",
        nickname = "getVirtualCsw")
    @RequestMapping(
        path = "/{identifier}",
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.GET)
    @ResponseStatus(value = HttpStatus.OK)
    @ApiResponses(value = {
        @ApiResponse(code = 404, message = "Resource not found.")
    })
    @ResponseBody
    public Service getVirtualCsw(
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_IDENTIFIER,
            required = true
        )
        @PathVariable
            int identifier
    ) throws Exception {
        Service service = serviceRepository.findOne(identifier);
        if (service == null) {
            throw new ResourceNotFoundException(String.format(
                "Virtual CSW with id '%d' does not exist.",
                identifier
            ));
        } else {
            setSchemaName(service);
            return service;
        }
    }


    @ApiOperation(
        value = "Add a virtual CSW",
        notes = "The service name MUST be unique. " +
            "An exception is returned if not the case.",
        authorizations = {
            @Authorization(value = "basicAuth")
        },
        nickname = "addVirtualCsw")
    @RequestMapping(
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.PUT
    )
    @ResponseStatus(HttpStatus.CREATED)
    @PreAuthorize("hasRole('Administrator')")
    @ApiResponses(value = {
        @ApiResponse(code = 201, message = "Return the identifier of the newly created service"),
        @ApiResponse(code = 404, message = "A service already exist with this name") ,
        @ApiResponse(code = 403, message = "Operation not allowed. Only Administrator can access it.")
    })
    @ResponseBody
    public ResponseEntity<Integer> addVirtualCsw(
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_DETAILS,
            required = true
        )
        @RequestBody
            Service service
    ) throws Exception {

        Service existing = serviceRepository.findOneByName(service.getName());
        if (existing != null) {
            throw new IllegalArgumentException(String.format(
                "A service already exist with this name '%s'. Choose another name.",
                service.getName()));
        }
        service.getParameters().forEach(p -> {
            p.setService(service);
        });

        serviceRepository.save(service);

        ApplicationContext applicationContext = ApplicationContextHolder.get();
        applicationContext.getBean(JeevesEngine.class)
            .loadConfigDB(applicationContext, service.getId());
        return new ResponseEntity<>(service.getId(), HttpStatus.CREATED);
    }

    @ApiOperation(
        value = "Update a virtual CSW",
        notes = "",
        authorizations = {
            @Authorization(value = "basicAuth")
        },
        nickname = "updateVirtualCsw")
    @RequestMapping(
        path = "/{identifier}",
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.PUT)
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
    @PreAuthorize("hasRole('Administrator')")
    @ApiResponses(value = {
        @ApiResponse(code = 204, message = "Service updated.") ,
        @ApiResponse(code = 404, message = "Resource not found.") ,
        @ApiResponse(code = 403, message = "Operation not allowed. Only Administrator can access it.")
    })
    public void updateVirtualCsw(
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_IDENTIFIER,
            required = true
        )
        @PathVariable
            int identifier,
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_DETAILS,
            required = true
        )
        @RequestBody
            Service service
    ) throws Exception {
        Service existing = serviceRepository.findOne(identifier);
        service.getParameters().forEach(p -> {
            p.setService(service);
        });
        if (existing != null) {
            serviceRepository.save(service);
        } else {
            throw new ResourceNotFoundException(String.format(
                "Virtual CSW with id '%d' does not exist.",
                identifier
            ));
        }
        ApplicationContext applicationContext = ApplicationContextHolder.get();
        applicationContext.getBean(JeevesEngine.class)
            .loadConfigDB(applicationContext, identifier);
    }

    @ApiOperation(
        value = "Remove a virtual CSW",
        notes = "After removal, all virtual CSW configuration is reloaded.",
        authorizations = {
            @Authorization(value = "basicAuth")
        },
        nickname = "deleteVirtualCsw")
    @RequestMapping(
        path = "/{identifier}",
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.DELETE)
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
    @PreAuthorize("hasRole('Administrator')")
    @ApiResponses(value = {
        @ApiResponse(code = 204, message = "Service removed.") ,
        @ApiResponse(code = 404, message = "Resource not found.") ,
        @ApiResponse(code = 403, message = "Operation not allowed. Only Administrator can access it.")
    })
    public void deleteVirtualCsw(
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_IDENTIFIER,
            required = true
        )
        @PathVariable
            int identifier
    ) throws Exception {
        Service existing = serviceRepository.findOne(identifier);
        if (existing != null) {
            serviceRepository.delete(identifier);

            ApplicationContext applicationContext = ApplicationContextHolder.get();
            applicationContext.getBean(JeevesEngine.class)
                .loadConfigDB(applicationContext, Integer.valueOf(identifier));
        } else {
            throw new ResourceNotFoundException(String.format(
                "Virtual CSW with id '%d' does not exist.",
                identifier
            ));
        }
    }


    @ApiOperation(
        value = "Get xsl from schema name ",
        notes = "",
        nickname = "getXslBySchema")
    @RequestMapping(
        path = "/xsl/{schema}",
        produces = MediaType.APPLICATION_JSON_VALUE,
        method = RequestMethod.GET)
    @ResponseStatus(value = HttpStatus.OK)
    @ApiResponses(value = {
        @ApiResponse(code = 404, message = "Resource not found.")
    })
    @ResponseBody
    public String [] getXslBySchema(
        @ApiParam(
            value = API_PARAM_CSW_SERVICE_IDENTIFIER,
            required = true
        )
        @PathVariable
            String schema
    ) throws Exception {
        Path cswDir = schemaManager.getSchemaCSWPresentDir(schema);
        Path path = cswDir.resolve("virtual");

        if (!Files.exists(path) && !Files.isDirectory(path)){
            return null;
        }
        List<String> filenames = new ArrayList<>();
        try(DirectoryStream<Path> files = Files.newDirectoryStream(path);){
            for (Path pathEntry:files){
                filenames.add(pathEntry.getFileName().toString());
            }
        }
        return filenames.toArray(new String [filenames.size()]);
    }

    private void setSchemaName (Service service){
        Optional<ServiceParam> param = service.getParameters().stream().filter(f->f.getName().equals("_schema"))
            .findFirst();
        param.ifPresent(s-> service.setSchemaName(s.getValue()));

    }

    private void update (Integer identifier, Service service) {
        serviceRepository.update(identifier, new Updater<Service>() {
            @Override
            public void apply(@Nonnull Service entity) {
                entity.setName(service.getName());
                entity.setDescription(service.getDescription());
                entity.setClassName(service.getClassName());
                entity.setExplicitQuery(service.getExplicitQuery());
                entity.setStylesheet(service.getStylesheet());
                entity.getParameters().clear();
                entity.getParameters().addAll(service.getParameters());
            }
        });
    }
}
