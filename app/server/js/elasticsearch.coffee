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
    @param {Object} body
    @return {goog.Promise}
  ###
  searchSongarySong: (body) ->
    @search index: 'songary', type: 'song', body: body

  ###*
    @return {goog.Promise}
  ###
  getRecentlyUpdatedSongs: ->
    @asSource @searchSongarySong
      sort: updatedAt: order: 'desc'

  ###*
    @param {string} urlArtist
    @param {string} urlName
    @return {goog.Promise}
  ###
  getSongsByUrl: (urlArtist, urlName) ->
    @asSource @searchSongarySong
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
    @asSource @searchSongarySong
      query: bool: should: [
        match: name: query: query, operator: 'and'
      ,
        match: artist: query: query, operator: 'and'
      ,
        multi_match:
          fields: ['lyricsForSearch', 'lyricsForSearch.folded']
          operator: 'and'
          query: query
          type: 'most_fields'
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
