goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @param {app.Storage} storage
    @constructor
    @extends {este.Routes}
  ###
  constructor: (@storage) ->
    super()

    @home = @route '/'
    @newSong = @route '/@me/songs/new'
    @song = @route '/@me/songs/:urlArtist/:urlName'
    @notFound = @route '*'