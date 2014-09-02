goog.provide 'app.Title'

class app.Title

  ###*
    Isomorphic app title.
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@routes, @userStore) ->

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_EDIT: goog.getMsg 'edit: '
  @MSG_HOME: goog.getMsg 'Songary | Your Songbook'
  @MSG_NEW_SONG: goog.getMsg 'New Song'
  @MSG_NOT_FOUND: goog.getMsg 'Page Not Found'
  @MSG_TRASH: goog.getMsg 'Trash'

  get: ->
    switch @routes.active
      when @routes.about then Title.MSG_ABOUT
      when @routes.editSong then @getEditSongTitle()
      when @routes.home then Title.MSG_HOME
      when @routes.mySong then @getMySongTitle()
      when @routes.newSong then Title.MSG_NEW_SONG
      when @routes.trash then Title.MSG_TRASH
      else Title.MSG_NOT_FOUND

  getMySongTitle: ->
    song = @userStore.songByRoute @routes.active
    return Title.MSG_NOT_FOUND if !song
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist}',
      name: song.getDisplayName()
      artist: song.getDisplayArtist()

  getEditSongTitle: ->
    Title.MSG_EDIT + @getMySongTitle()
