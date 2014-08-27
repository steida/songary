goog.provide 'app.Title'

class app.Title

  ###*
    Isomorphic app title.
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@routes, @userStore) ->

  @MSG_EDIT: goog.getMsg 'edit: '
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'
  @MSG_MY_NEW_SONG: goog.getMsg 'New Song | Songary'
  @MSG_NOT_FOUND: goog.getMsg 'Page Not Found'

  get: ->
    switch @routes.active
      when @routes.home then Title.MSG_HOME
      when @routes.myNewSong then Title.MSG_MY_NEW_SONG
      when @routes.mySong then @getMySongTitle()
      when @routes.editMySong then @getEditMySongTitle()
      else Title.MSG_NOT_FOUND

  getMySongTitle: ->
    song = @userStore.songByRoute @routes.active
    return Title.MSG_NOT_FOUND if !song
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist} | Songary',
      name: song.getDisplayName()
      artist: song.getDisplayArtist()

  getEditMySongTitle: ->
    Title.MSG_EDIT + @getMySongTitle()
