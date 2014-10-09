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
    @delete = @toPromise @client.delete
    @index = @toPromise @client.index
    @search = @toPromise @client.search

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
    @asList @withoutMetas @searchSongarySong sort: updatedAt: order: 'desc'

  ###*
    @param {string} urlArtist
    @param {string} urlName
    @return {goog.Promise}
  ###
  getSongsByUrl: (urlArtist, urlName) ->
    @withoutMetas @searchSongarySong
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
    @asList @withoutMetas @searchSongarySong
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
    Transform ElasticSearch callbacks into goog.Promise.
    @param {Function} fn
    @return {Function}
    @private
  ###
  toPromise: (fn) ->
    (params) =>
      new goog.Promise (resolve, reject) =>
        fn.call @client, params, (error, response) ->
          if error
            reject error
            return
          resolve response

  ###*
    Omit ElasticSearch metas.
    @param {goog.Promise} promise
    @return {goog.Promise}
    @private
  ###
  withoutMetas: (promise) ->
    promise.then (response) ->
      response.hits.hits.map (hit) -> hit._source

  ###*
    Just props for listing.
    @param {goog.Promise} promise
    @return {goog.Promise}
    @private
  ###
  asList: (promise) ->
    promise.then (songs) ->
      songs.map (song) ->
        artist: song.artist
        name: song.name
        urlArtist: song.urlArtist
        urlName: song.urlName
