goog.provide 'app.songs.Song'

goog.require 'app.ValidationError'
goog.require 'este.string'

class app.songs.Song

  ###*
    @constructor
  ###
  constructor: () ->
    ###*
      @type {string}
      @const
    ###
    @id = goog.string.getRandomString()

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
  ###
  created: ''

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
  ###
  updated: ''

  ###*
    @type {string}
  ###
  name: ''

  ###*
    @type {string}
  ###
  urlName: ''

  ###*
    @type {string}
  ###
  artist: ''

  ###*
    @type {string}
  ###
  urlArtist: ''

  ###*
    User id.
    @type {string}
  ###
  creator: ''

  ###*
    http://linkesoft.com/songbook/chordproformat.html
    @type {string}
  ###
  lyrics: ''

  ###*
    @return {Array.<app.ValidationError>}
  ###
  validate: ->
    @update()
    ['name', 'artist', 'lyrics']
      .filter (prop) => !@[prop].trim()
      .map (prop) =>
        Song.MSG_FILL_OUT = goog.getMsg 'Please fill out {$prop}.', prop: prop
        new app.ValidationError prop, Song.MSG_FILL_OUT

  update: ->
    # PATTERN(steida): Look, we really don't need to use html5 form validation.
    @name = @name.slice 0, 100
    @artist = @artist.slice 0, 100
    @lyrics = @lyrics.slice 0, 32000
    @urlName = este.string.toFancyUrl @name
    @name = '' if !@urlName
    @urlArtist = este.string.toFancyUrl @artist
    @artist = '' if !@urlArtist