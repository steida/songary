goog.provide 'app.songs.Song'

goog.require 'app.ValidationError'
goog.require 'este.string'

class app.songs.Song

  ###*
    @param {string=} name
    @param {string=} artist
    @param {string=} lyrics
    @constructor
  ###
  constructor: (
    @name = ''
    @artist = ''
    @lyrics = '') ->

  ###*
    ID is an empty string until first sync aka user is logged or created.
    @type {string}
    @expose
  ###
  id: ''

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
    @expose
  ###
  created: ''

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
    @expose
  ###
  updated: ''

  ###*
    @type {string}
    @expose
  ###
  name: ''

  ###*
    @type {string}
    @expose
  ###
  urlName: ''

  ###*
    @type {string}
    @expose
  ###
  artist: ''

  ###*
    @type {string}
    @expose
  ###
  urlArtist: ''

  ###*
    User id.
    @type {string}
    @expose
  ###
  creator: ''

  ###*
    http://linkesoft.com/songbook/chordproformat.html
    @type {string}
    @expose
  ###
  lyrics: ''

  ###*
    @return {Array.<app.ValidationError>}
  ###
  validate: ->
    errors = ['name', 'artist', 'lyrics']
      .filter (name) => !@[name].trim()
      .map (name) =>
        @MSG_PLEASE_FILL_OUT = goog.getMsg 'Please fill out {$name}.', name: name
        new app.ValidationError name, @MSG_PLEASE_FILL_OUT
    errors

  ###*
    Compute urls after set.
  ###
  updateUrlNames: ->
    @urlName = este.string.toFancyUrl @name
    @urlArtist = este.string.toFancyUrl @artist

  ###*
    @param {string} prop
    @param {string} value
  ###
  setProp: (prop, value) ->
    @[prop] = value
    @updateUrlNames()