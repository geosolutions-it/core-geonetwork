/*
 * Copyright (C) 2001-2020 Food and Agriculture Organization of the
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

package org.fao.geonet.api.processing;

import jeeves.server.context.ServiceContext;

import org.fao.geonet.domain.AbstractMetadata;
import org.fao.geonet.domain.Metadata;
import org.fao.geonet.domain.MetadataType;
import org.fao.geonet.kernel.SchemaManager;
import org.fao.geonet.kernel.datamanager.IMetadataManager;
import org.fao.geonet.repository.MetadataValidationRepository;
import org.fao.geonet.repository.SourceRepository;
import org.fao.geonet.services.AbstractServiceIntegrationTest;
import org.fao.geonet.utils.Xml;
import org.jdom.Element;
import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.net.URL;
import java.util.UUID;

import static org.fao.geonet.kernel.UpdateDatestamp.NO;
import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

public class ValidateApiTest extends AbstractServiceIntegrationTest {

    @Autowired
    private WebApplicationContext wac;
    @Autowired
    private SchemaManager schemaManager;
    @Autowired
    private IMetadataManager dataManager;
    @Autowired
    private SourceRepository sourceRepository;
    @Autowired
    MetadataValidationRepository metadataValidationRepository;

    private ServiceContext context;

    @Test
    public void testErrorsMessageIsPresentIfNotValid() throws Exception {
        AbstractMetadata metadata = metadataOnLineResourceDbInsert(
            MetadataType.METADATA, getClass().getResource("invalid-metadata.iso19139.xml"));

        MockMvc toTest = MockMvcBuilders.webAppContextSetup(this.wac).build();
        MockHttpSession mockHttpSession = loginAsAdmin();
        toTest.perform(put("/srv/api/records/validate")
            .param("uuids", new String [] {metadata.getUuid()})
            .session(mockHttpSession)
            .accept(MediaType.APPLICATION_JSON))
            .andExpect(status().is2xxSuccessful())
            .andExpect(content().string(
                containsString("Validation of type xsd failed with 1 error.")));
    }

    private AbstractMetadata metadataOnLineResourceDbInsert(MetadataType type, URL resource) throws Exception {
        loginAsAdmin(context);
        Element sampleMetadataXml = Xml.loadStream(resource.openStream());

        Metadata metadata = new Metadata();
        metadata
            .setDataAndFixCR(sampleMetadataXml)
            .setUuid(UUID.randomUUID().toString());
        metadata.getDataInfo()
            .setRoot(sampleMetadataXml.getQualifiedName())
            .setSchemaId(schemaManager.autodetectSchema(sampleMetadataXml))
            .setType(type)
            .setPopularity(1000);
        metadata.getSourceInfo()
            .setOwner(42)
            .setSourceId(sourceRepository.findAll().get(0).getUuid());
        metadata.getHarvestInfo()
            .setHarvested(false);

        AbstractMetadata dbInsertedMetadata = dataManager.insertMetadata(
            context,
            metadata,
            sampleMetadataXml,
            false,
            false,
            false,
            NO,
            false,
            false);

        return dbInsertedMetadata;
    }

    @Before
    public void setUp() throws Exception {
        this.context = createServiceContext();
    }
}
