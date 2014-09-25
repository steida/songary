module.exports = ->
  require '../bower_components/closure-library/closure/goog/bootstrap/nodejs.js'
  require '../tmp/deps.js'

  config = require '../app/server/config'
  elasticsearch = require 'elasticsearch'

  client = new elasticsearch.Client host: config['elasticSearch']['host']

  #   .then (resp) ->
  #     songs = resp.hits.hits.map (hit) -> hit._source
  #     console.log songs.length
  #   .catch (reason) ->
  #     console.log reason
