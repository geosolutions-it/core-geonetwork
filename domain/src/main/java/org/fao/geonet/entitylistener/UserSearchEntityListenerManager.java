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

package org.fao.geonet.entitylistener;

import org.fao.geonet.domain.UserSearch;
import javax.persistence.*;

public class UserSearchEntityListenerManager extends AbstractEntityListenerManager<UserSearch> {
    @PrePersist
    public void prePresist(final UserSearch entity) {
        handleEvent(PersistentEventType.PrePersist, entity);
    }

    @PreRemove
    public void preRemove(final UserSearch entity) {
        handleEvent(PersistentEventType.PreRemove, entity);
    }

    @PostPersist
    public void postPersist(final UserSearch entity) {
        handleEvent(PersistentEventType.PostPersist, entity);
    }

    @PostRemove
    public void postRemove(final UserSearch entity) {
        handleEvent(PersistentEventType.PostRemove, entity);
    }

    @PreUpdate
    public void preUpdate(final UserSearch entity) {
        handleEvent(PersistentEventType.PreUpdate, entity);
    }

    @PostUpdate
    public void postUpdate(final UserSearch entity) {
        handleEvent(PersistentEventType.PostUpdate, entity);
    }

    @PostLoad
    public void postLoad(final UserSearch entity) {
        handleEvent(PersistentEventType.PostLoad, entity);
    }

}
