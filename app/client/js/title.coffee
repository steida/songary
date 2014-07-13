goog.provide 'app.Title'

goog.require 'goog.net.HttpStatus'

class app.Title

  ###*
    @param {app.Routes} routes
    @param {app.Store} appStore
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (@routes, @appStore, @songsStore) ->

  ###*
    @return {string}
  ###
  get: ->
    switch @appStore.httpStatus
      when goog.net.HttpStatus.NOT_FOUND then return Title.MSG_NOT_FOUND

    switch @routes.active
      when @routes.home then Title.MSG_HOME
      when @routes.myNewSong then Title.MSG_NEW_SONG
      when @routes.mySong then @getSongTitle()
      else Title.MSG_NOT_FOUND

  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'
  @MSG_NEW_SONG: goog.getMsg 'New Song | Songary'
  @MSG_NOT_FOUND: goog.getMsg 'Page Not Found'

  getSongTitle: ->
    song = @songsStore.song
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist} | Songary',
      name: song.name
      artist: song.artist