goog.provide 'app.songs.Song'

goog.require 'app.ValidationError'
goog.require 'este.string'

class app.songs.Song

  ###*
    TODO: Create base este.Model.
    @param {Object=} json
    @constructor
  ###
  constructor: (json) ->
    @id = goog.string.getRandomString()
    goog.mixin @, json if json

  @MSG_MISSING_LYRICS: goog.getMsg 'missing lyrics'
  @MSG_NOT_PUBLISHED: goog.getMsg 'Song must be published.'
  @MSG_UNKNOWN_ALBUM: goog.getMsg 'unknown album'
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
    Optional.
    @type {string}
  ###
  album: ''

  ###*
    @type {string}
  ###
  urlAlbum: ''

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
    ISO string.
    @type {?string}
  ###
  updatedAt: null

  ###*
    @return {goog.Promise}
  ###
  validate: ->
    @computeProps()
    errors = ['name', 'artist', 'lyrics']
      .filter (prop) => !@[prop].trim()
      .map (prop) ->
        msg: "Please fill out #{prop}."
        props: [prop]
    app.ValidationError.toPromise errors

  # ###
  #   @return {Array.<app.ValidationError>}
  # ###
  # validatePublished: ->
  #   errors = @validate()
  #   if !@publisher
  #     errors.push new app.ValidationError 'publisher', Song.MSG_NOT_PUBLISHED
  #   errors

  ###*
    Compute props. Add new or restrict existing. Props can be in invalid state,
    for example after deserialization, hence use this method to the rescue.
  ###
  computeProps: ->
    @name = @name.slice 0, 100
    @artist = @artist.slice 0, 100
    @album = @album.slice 0, 100
    @lyrics = @lyrics.slice 0, 32000

    @urlName = este.string.toFancyUrl @name
    @name = '' if !@urlName

    @urlArtist = este.string.toFancyUrl @artist
    @artist = '' if !@urlArtist

    @urlAlbum = este.string.toFancyUrl @album
    @album = '' if !@urlAlbum

    @updatedAt = new Date().toISOString()

  getDisplayName: ->
    @name || Song.MSG_UNKNOWN_NAME

  getDisplayArtist: ->
    @artist || Song.MSG_UNKNOWN_ARTIST

  getDisplayAlbum: ->
    @album || Song.MSG_UNKNOWN_ALBUM

  getDisplayLyrics: ->
    @lyrics || Song.MSG_MISSING_LYRICS
