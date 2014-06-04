goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @constructor
    @extends {este.Routes}
  ###
  constructor: ->
    super()
    @home = new este.Route '/',
      'Songary | Your personal songbook'
    @newSong = new este.Route '/songs/new/:operation?',
      'New Song | Songary'

    @list = [
      @home
      @newSong
    ]