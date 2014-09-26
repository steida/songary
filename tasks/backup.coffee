module.exports = ->
  require '../bower_components/closure-library/closure/goog/bootstrap/nodejs.js'
  require '../tmp/deps.js'

  config = require '../app/server/config'
  elasticsearch = require 'elasticsearch'
  fs = require 'fs'
  path = require 'path'

  goog.require 'goog.array'

  client = new elasticsearch.Client host: config['elasticSearch']['host']

  # For some unknown reason the gulp task doesn't finish when client .search
  # is called. Wait with fix for a new gulp.
  client
    .search
      index: 'songary'
      type: 'song'
      size: 10000
    .then (resp) ->
      songsAsSource = resp.hits.hits.map (hit) -> hit._source
      goog.array.sortObjectsByKey songsAsSource, 'name'
      songsAsString = JSON.stringify songsAsSource, null, '  '
      filepath = path.join __dirname, '../backup/songs.json'
      fs.writeFileSync filepath, songsAsString
      console.log 'Songs saved: ' + filepath
    .catch (reason) ->
      console.log reason
