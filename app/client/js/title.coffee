goog.provide 'app.Title'

class app.Title

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (@routes, @songsStore) ->

  ###*
    @return {string}
  ###
  get: ->
    switch @routes.active
      when @routes.home then Title.MSG_HOME
      when @routes.myNewSong then Title.MSG_NEW_SONG
      when @routes.mySong then @getSongTitle()
      else ''

  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'
  @MSG_NEW_SONG: goog.getMsg 'New Song | Songary'

  getSongTitle: ->
    song = @songsStore.song
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist} | Songary',
      name: song?.name
      artist: song?.artist