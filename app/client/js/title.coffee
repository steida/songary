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
      when @routes.newSong then Title.MSG_NEW_SONG
      when @routes.song then @getSongTitle()
      else ''

  ###*
    @desc app.Title
  ###
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'

  ###*
    @desc app.Title
  ###
  @MSG_NEW_SONG: goog.getMsg 'New Song | Songary'

  getSongTitle: ->
    song = @songsStore.song
    ###*
      @desc app.Title
    ###
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist} | Songary',
      name: song?.name
      artist: song?.artist