/*
 * Copyright (C) 2011 Intel Corporation.
 *
 * Contact: Iago Toral Quiroga <itoral@igalia.com>
 *
 * Authors: Lionel Landwerlin <lionel.g.landwerlin@linux.intel.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA
 *
 */

#ifndef _GRL_TRACKER_UTILS_H_
#define _GRL_TRACKER_UTILS_H_

#include "grl-tracker.h"

/* ------- Definitions ------- */

#define RDF_TYPE_ALBUM  "nmm#MusicAlbum"
#define RDF_TYPE_ARTIST "nmm#Artist"
#define RDF_TYPE_AUDIO  "nfo#Audio"
#define RDF_TYPE_MUSIC  "nmm#MusicPiece"
#define RDF_TYPE_IMAGE  "nmm#Photo"
#define RDF_TYPE_VIDEO  "nmm#Video"
#define RDF_TYPE_BOX    "grilo#Box"

#define RDF_TYPE_VOLUME "tracker#Volume"
#define RDF_TYPE_UPNP   "upnp#ContentDirectory"

/**/

typedef struct {
  GrlKeyID     grl_key;
  const gchar *sparql_key_name;
  const gchar *sparql_key_attr;
  const gchar *sparql_key_flavor;
} tracker_grl_sparql_t;

void grl_tracker_setup_key_mappings (void);

tracker_grl_sparql_t *grl_tracker_get_mapping_from_sparql (const gchar *key);

GrlMedia *grl_tracker_build_grilo_media (const gchar *rdf_type);

gchar *grl_tracker_source_get_device_constraint (GrlTrackerSourcePriv *priv);

gchar *grl_tracker_source_get_select_string (GrlMediaSource *source,
                                             const GList *keys);

gchar *grl_tracker_get_source_name (const gchar *rdf_type,
                                    const gchar *uri,
                                    const gchar *datasource,
                                    const gchar *datasource_name);

#endif /* _GRL_TRACKER_UTILS_H_ */
