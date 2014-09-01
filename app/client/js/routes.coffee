goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @constructor
    @extends {este.Routes}
  ###
  constructor: ->
    @home = @route '/'
    @newSong = @route '/@me/songs/new'
    @editSong = @route '/@me/songs/:id/edit'
    @mySong = @route '/@me/songs/:id'
