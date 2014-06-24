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
    @newSong = new este.Route '/@me/songs/new', Routes.MSG_NEW_SONG
    @song = new este.Route '/@me/songs/:urlArtist/:urlName', 'Routes.MSG_NEW_SONG'

    @list = [
      @home
      @newSong
      @song
    ]

  ###*
    @desc app.Routes
  ###
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'

  ###*
    @desc app.Routes
  ###
  @MSG_NEW_SONG: goog.getMsg 'New Song | Songary'

  # ###*
  #   @desc app.Routes
  # ###
  # @MSG_SONG: goog.getMsg '{$songName} - {$artist} | Songary'