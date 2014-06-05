goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @constructor
    @extends {este.Routes}
  ###
  constructor: ->
    super()
    @home = new este.Route '/', Routes.MSG_HOME
    @newSong = new este.Route '/songs/new', Routes.MSG_NEW_SONG

    @list = [
      @home
      @newSong
    ]

  ###*
    @desc app.Routes
  ###
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'

  ###*
    @desc app.Routes
  ###
  @MSG_NEW_SONG: goog.getMsg 'New Song | Songary'