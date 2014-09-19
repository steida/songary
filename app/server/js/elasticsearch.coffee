goog.provide 'server.ElasticSearch'

goog.require 'goog.Promise'

class server.ElasticSearch

  ###*
    @param {Object} elasticSearch
    @param {string} host
    @constructor
  ###
  constructor: (elasticSearch, host) ->
    @client = new elasticSearch['Client'] 'host': host

    # @client.ping
    #   # ping usually has a 100ms timeout
    #   requestTimeout: 500
    #
    #   # undocumented params are appended to the query string
    #   hello: "elasticsearch!"
    # , (error) ->
    #   if error
    #     console.trace "elasticsearch cluster is down!"
    #   else
    #     console.log "All is well"
    #   return
