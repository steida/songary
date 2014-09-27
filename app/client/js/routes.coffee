goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @param {app.user.Store} userStore
    @constructor
    @extends {este.Routes}
  ###
  constructor: (userStore) ->
    @home = @route '/'
    @about = @route '/about'
    @songs = @route '/songs'
    @recentlyUpdatedSongs = @route '/songs/recently-updated'
    @song = @route '/:urlArtist/:urlName'

    @me = @route '/@me'
    @newSong = @route '/@me/songs/new'
    @trash = @route '/@me/songs/trash'
    @editSong = @route '/@me/songs/:id/edit'
    @mySong = @route '/@me/songs/:id'

    @api =
      song: new este.Route '/api/songs/:id'
      recentlyUpdatedSongs: new este.Route '/api/songs/recently-updated'
      songsByUrl: new este.Route '/api/songs/:urlArtist/:urlName'
      clientErrors: new este.Route '/api/client-errors'
