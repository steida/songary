goog.provide 'server.ElasticSearch'

goog.require 'goog.Promise'

class server.ElasticSearch

  ###*
    @param {Object} elasticSearch
    @param {string} host
    @constructor
  ###
  constructor: (elasticSearch, host) ->
    @client = new elasticSearch.Client host: host

    @index = @toPromise_ @client.index
    @delete = @toPromise_ @client.delete
    @search = @toPromise_ @client.search

  ###*
    @param {Function} fn
    @return {Function}
    @private
  ###
  toPromise_: (fn) ->
    (params) =>
      new goog.Promise (resolve, reject) =>
        fn.call @client, params, (error, response) ->
          if error
            reject error
            return
          resolve response
