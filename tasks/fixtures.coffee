elasticsearch = require 'elasticsearch'

config = require '../app/server/config'
songs = require '../backup/songs.json'

require '../bower_components/closure-library/closure/goog/bootstrap/nodejs.js'
require '../tmp/deps.js'

goog.require 'goog.Promise'
goog.require 'server.songs'

module.exports = ->

  client = new elasticsearch.Client host: config['elasticSearch']['host']
  indices = client.indices

  indices.exists index: 'songary'
    .then (exists) ->
      if exists
        return indices.delete index: 'songary'
    .then ->
      indices.create index: 'songary'
    .then ->
      indices.close index: 'songary'
    .then ->
      indices.putSettings
        index: 'songary'
        body:
          analysis:
            analyzer:
              folding:
                tokenizer: 'standard'
                filter: ['lowercase', 'asciifolding']
    .then ->
      indices.putMapping
        index: 'songary'
        type: 'song'
        body:
          properties:
            # http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_finding_exact_values.html
            urlName: type: 'string', index: 'not_analyzed'
            language: type: 'string', index: 'not_analyzed'
            urlArtist: type: 'string', index: 'not_analyzed'
            lyricsForSearch:
              type: 'string'
              analyzer: 'standard'
              fields:
                folded:
                  type: 'string'
                  analyzer: 'folding'
            publisher: type: 'string', index: 'not_analyzed'
    .then ->
      indices.open index: 'songary'
    .then ->
      goog.Promise.all songs.map (song) ->
        id = song.id
        updatedAt = song.updatedAt
        delete song.id
        delete song.updatedAt
        server.songs.toPublishedJson song, song.updatedAt
          .then (song) ->
            client.index index: 'songary', type: 'song', id: id, body: song
    .catch (reason) ->
      console.log reason
