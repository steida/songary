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

  getLastTenSongs: ->
    @asSource @search index: 'songary', type: 'song', body:
      sort: updatedAt: order: 'desc'

  getSongsByUrl: (urlArtist, urlName) ->
    @asSource @search index: 'songary', type: 'song', body:
      query: filtered: filter: bool: must: [
        term: urlName: urlName
      ,
        term: urlArtist: urlArtist
      ]

  asSource: (promise) ->
    promise.then (response) ->
      response.hits.hits.map (hit) -> hit._source

  ###*
    ElasticSearch promises missing thenCatch method, so transform it to goog.Promise.
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
