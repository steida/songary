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

    @api = @routes '/api',
      clientErrors: '/client-errors'
      songs: @routes '/songs',
        byUrl: '/:urlArtist/:urlName'
        id: '/:id'
        recentlyUpdated: '/recently-updated'
        search: '/search'
