goog.provide 'app.Title'

goog.require 'goog.net.HttpStatus'

class app.Title

  ###*
    @param {app.Routes} routes
    @param {app.Store} appStore
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@routes, @appStore, @userStore) ->

  @MSG_EDIT: goog.getMsg 'edit: '
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'
  @MSG_MY_NEW_SONG: goog.getMsg 'New Song | Songary'
  @MSG_NOT_FOUND: goog.getMsg 'Page Not Found'

  ###*
    @return {string}
  ###
  get: ->
    switch @appStore.httpStatus
      when goog.net.HttpStatus.NOT_FOUND then return Title.MSG_NOT_FOUND

    switch @routes.active
      when @routes.home then Title.MSG_HOME
      when @routes.myNewSong then Title.MSG_MY_NEW_SONG
      # TODO(steida): Add 'if not userStore.songByRoute routes.active' check.
      when @routes.mySong then @getMySongTitle()
      when @routes.editMySong then @getEditMySongTitle()
      else Title.MSG_NOT_FOUND


  getMySongTitle: ->
    song = @userStore.songByRoute @routes.active
    return if !song
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist} | Songary',
      name: song.getDisplayName()
      artist: song.getDisplayArtist()

  getEditMySongTitle: ->
    Title.MSG_EDIT + @getMySongTitle()