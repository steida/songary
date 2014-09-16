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
    @song = @route '/:urlArtist/:urlName'
    @me = @route '/@me'
    @newSong = @route '/@me/songs/new'
    @trash = @route '/@me/songs/trash'
    @editSong = @route '/@me/songs/:id/edit'
    @mySong = @route '/@me/songs/:id'

    @api =
      song: @route '/api/songs/:id'

    ###*
      @param {string} songId
      @return {string}
    ###
    @myPublishedSongUrl = (songId) ->
      '/' + userStore.publishedSongs[songId]
