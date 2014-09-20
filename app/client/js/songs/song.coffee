goog.provide 'app.songs.Song'

goog.require 'app.ValidationError'
goog.require 'este.string'

class app.songs.Song

  ###*
    @constructor
  ###
  constructor: ->
    @id = goog.string.getRandomString()

  @MSG_MISSING_LYRICS: goog.getMsg 'missing lyrics'
  @MSG_UNKNOWN_ARTIST: goog.getMsg 'unknown artist'
  @MSG_UNKNOWN_NAME: goog.getMsg 'unknown name'
  @MSG_NOT_PUBLISHED: goog.getMsg 'Song must be published.'

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
    @type {?string}
  ###
  publisher: null

  ###*
    @return {boolean}
  ###
  isPublished: ->
    !!@publisher

  ###*
    @type {?number}
  ###
  updatedAt: null

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

  ###*
    @return {Array.<app.ValidationError>}
  ###
  validatePublished: ->
    errors = @validate()
    if !@publisher
      errors.push new app.ValidationError 'publisher', Song.MSG_NOT_PUBLISHED
    errors

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

  toJson: ->
    JSON.parse JSON.stringify @
