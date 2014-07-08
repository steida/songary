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
    # TODO(steida): Rename it to newMySong.
    @newSong = @route '/@me/songs/new'
    @mySong = @route '/@me/songs/:urlArtist/:urlName'
    @editMySong = @route '/@me/songs/:urlArtist/:urlName/edit'
    @notFound = @route '*'