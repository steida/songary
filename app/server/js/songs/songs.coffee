cld = require 'cld'

goog.provide 'server.songs'

goog.require 'goog.Promise'

###*
  @param {Object} json
  @param {string=} updatedAt
  @param {Function=} createIsoDate
  @return {goog.Promise}
###
server.songs.toPublishedJson = (json, updatedAt, createIsoDate) ->
  createIsoDate ?= -> new Date().toISOString()

  new goog.Promise (resolve, reject) ->
    publishedJson = {}
    goog.mixin publishedJson, json
    publishedJson.lyricsForSearch = server.songs.getText json.lyrics
    cld.detect publishedJson.lyricsForSearch, (err, result) ->
      if err
        reject err
      else
        publishedJson.language = result?.languages?[0]?.code || ''
        publishedJson.updatedAt = if updatedAt
          updatedAt
        else
          createIsoDate()
        resolve publishedJson

###*
  http://linkesoft.com/songbook/chordproformat.html.
  @type {RegExp}
###
server.songs.chordRegex = /\[([^\]]*)\]/g

###*
  http://linkesoft.com/songbook/chordproformat.html.
  @type {RegExp}
###
server.songs.controlSequencesRegex = /\{([^\}]*)\}/g

###*
  @param {string} lyrics Lyrics in chordpro format.
  @return {string}
###
server.songs.getText = (lyrics) ->
  lyrics
    .replace server.songs.chordRegex, -> ''
    .replace server.songs.controlSequencesRegex, -> ''
    .trim()
