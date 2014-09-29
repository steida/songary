goog.provide 'server.ElasticSearch'

goog.require 'goog.Promise'

class server.ElasticSearch

  ###*
    @param {Object} elasticSearch
    @param {string} host
    @constructor
    @final
  ###
  constructor: (elasticSearch, host) ->
    @client = new elasticSearch.Client host: host

    @delete = @toPromise_ @client.delete
    @index = @toPromise_ @client.index
    @search = @toPromise_ @client.search

  ###*
    @param {goog.Promise} promise
    @return {goog.Promise}
  ###
  asSource: (promise) ->
    promise.then (response) ->
      response.hits.hits.map (hit) -> hit._source

  ###*
    @return {goog.Promise}
  ###
  getRecentlyUpdatedSongs: ->
    @asSource @search index: 'songary', type: 'song', body:
      sort: updatedAt: order: 'desc'

  ###*
    @param {string} urlArtist
    @param {string} urlName
    @return {goog.Promise}
  ###
  getSongsByUrl: (urlArtist, urlName) ->
    @asSource @search index: 'songary', type: 'song', body:
      query: filtered: filter: bool: must: [
        term: urlName: urlName
      ,
        term: urlArtist: urlArtist
      ]

  ###*
    @param {string} query
    @return {goog.Promise}
  ###
  searchSongsByQuery: (query) ->
    # TODO: Ignore diacritics, boost name and artist, use detected language.
    @asSource @search index: 'songary', type: 'song', body:
      query: bool: should: [
        match: name: query: query, operator: 'and'
      ,
        match: artist: query: query, operator: 'and'
      ,
        match: lyrics: query: query, operator: 'and'
      ]

  ###*
    Transform ElasticSearch callbacks to goog.Promise since I prefer it.
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
