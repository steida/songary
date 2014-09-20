module.exports = ->
  require '../bower_components/closure-library/closure/goog/bootstrap/nodejs.js'
  require '../tmp/deps.js'

  config = require '../app/server/config'
  elasticsearch = require 'elasticsearch'

  client = new elasticsearch.Client host: config['elasticSearch']['host']

  client.indices.exists index: 'songary'
    .then (exists) ->
      if exists
        return client.indices.delete index: 'songary'
    .then ->
      return client.indices.create index: 'songary'
    .then ->
      return client.indices.putMapping
        index: 'songary'
        type: 'song'
        body:
          song:
            properties:
              # http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_finding_exact_values.html
              urlName: type: 'string', index: 'not_analyzed'
              urlArtist: type: 'string', index: 'not_analyzed'
              publisher: type: 'string', index: 'not_analyzed'
    .catch (reason) ->
      console.log reason
