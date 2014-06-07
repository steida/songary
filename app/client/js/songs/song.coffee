goog.provide 'app.songs.Song'

class app.songs.Song

  ###*
    @constructor
  ###
  constructor: ->

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