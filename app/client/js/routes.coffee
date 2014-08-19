goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @constructor
    @extends {este.Routes}
  ###
  constructor: ->
    @home = @route '/'
    @myNewSong = @route '/@me/songs/new'
    @mySong = @route '/@me/songs/:id'
    @editMySong = @route '/@me/songs/:id/edit'
