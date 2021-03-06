--[[
 * Copyright (C) 2016 Grilo Project
 *
 * Contact: Victor Toso <me@victortoso.com>
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
--]]

---------------------------
-- Source initialization --
---------------------------

source = {
  id = "grl-acoustid",
  name = "Acoustid",
  description = "a source that provides audio identification",
  supported_keys = { "title", "album", "artist", "mb-recording-id", "mb-album-id", "mb-artist-id" },
  supported_media = { 'audio' },
  config_keys = {
    required = { "api-key" },
  },
  resolve_keys = {
    ["type"] = "audio",
    required = { "duration", "chromaprint" }
  },
  tags = { 'music', 'net:internet' },
}

netopts = {
  user_agent = "Grilo Source AcoustID/0.3.0",
}

------------------
-- Source utils --
------------------
acoustid = {}

-- https://acoustid.org/webservice#lookup
ACOUSTID_LOOKUP = "https://api.acoustid.org/v2/lookup?client=%s&meta=recordings+releasegroups&duration=%d&fingerprint=%s"

---------------------------------
-- Handlers of Grilo functions --
---------------------------------
function grl_source_init (configs)
    acoustid.api_key = configs.api_key
    return true
end

function grl_source_resolve (media, options, callback)
  local url
  local media = grl.get_media_keys()

  if not media or
      not media.duration or
      not media.chromaprint or
      #media.chromaprint == 0 then
    grl.callback ()
    return
  end

  url = string.format (ACOUSTID_LOOKUP, acoustid.api_key, media.duration,
                       media.chromaprint)
  grl.fetch (url, netopts, lookup_cb)
end

---------------
-- Utilities --
---------------

function lookup_cb (feed)
  if not feed then
    grl.callback()
    return
  end

  local json = grl.lua.json.string_to_table (feed)
  if not json or json.status ~= "ok" then
    grl.callback()
  end

  media = build_media (json.results)
  grl.callback (media)
end


function build_media(results)
  local media = grl.get_media_keys ()
  local keys = grl.get_requested_keys ()
  local record, album, artist

  if results and #results > 0 and
      results[1].recordings and
      #results[1].recordings > 0 then
    record = results[1].recordings[1]

    media.title = keys.title and record.title or nil
    media.mb_recording_id = keys.mb_recording_id and record.id or nil
  end

  if record and
      record.releasegroups and
      #record.releasegroups > 0 then

    album = record.releasegroups[1]
    media.album = keys.album and album.title or nil
    media.mb_album_id = keys.mb_album_id and album.id or nil
  end

  -- FIXME: related-keys on lua sources are in the TODO list
  -- https://bugzilla.gnome.org/show_bug.cgi?id=756203
  -- and for that reason we are only returning first of all metadata
  if record and record.artists and #record.artists > 0 then
    artist = record.artists[1]
    media.artist = keys.artist and artist.name or nil
    media.mb_artist_id = keys.mb_artist_id and artist.id or nil
  end

  return media
end
