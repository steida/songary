goog.provide 'app.songs.Song'

goog.require 'app.ValidationError'

class app.songs.Song

  ###*
    @param {string} name
    @param {string} chordpro
    @constructor
  ###
  constructor: (@name, @chordpro) ->

  @MSG_PLEASE_FILL_OUT_NAME: goog.getMsg 'Please fill out name.'
  @MSG_PLEASE_FILL_OUT_CHORDPRO: goog.getMsg 'Please fill out chordpro.'

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
  author: ''

  ###*
    @type {string}
    @expose
  ###
  interpret: ''

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
  chordpro: ''

  ###*
    @return {Array.<app.ValidationError>}
  ###
  validate: ->
    errors = []

    if !@name.trim()
      errors.push new app.ValidationError 'name',
        Song.MSG_PLEASE_FILL_OUT_NAME

    if !@chordpro.trim()
      errors.push new app.ValidationError 'chordpro',
        Song.MSG_PLEASE_FILL_OUT_CHORDPRO

    errors