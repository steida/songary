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

  @MSG_MISSING_LYRICS: goog.getMsg 'missing lyrics'
  @MSG_UNKNOWN_ARTIST: goog.getMsg 'unknown artist'
  @MSG_UNKNOWN_NAME: goog.getMsg 'unknown name'

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
    http://linkesoft.com/songbook/chordproformat.html
    @type {string}
  ###
  lyrics: ''

  ###*
    @type {boolean}
  ###
  inTrash: false

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
    @name = @name.slice 0, 100
    @artist = @artist.slice 0, 100
    @lyrics = @lyrics.slice 0, 32000

    @urlName = este.string.toFancyUrl @name
    @name = '' if !@urlName

    @urlArtist = este.string.toFancyUrl @artist
    @artist = '' if !@urlArtist

  getDisplayName: ->
    @name || Song.MSG_UNKNOWN_NAME

  getDisplayArtist: ->
    @artist || Song.MSG_UNKNOWN_ARTIST

  getDisplayLyrics: ->
    @lyrics || Song.MSG_MISSING_LYRICS
