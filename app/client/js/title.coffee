goog.provide 'app.Title'

class app.Title

  ###*
    Isomorphic app title.
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (@routes, @userStore, @songsStore) ->

  @MSG_ABOUT: goog.getMsg 'About'
  @MSG_EDIT: goog.getMsg 'Edit: '
  @MSG_HOME: goog.getMsg 'Songary | Your Songbook'
  @MSG_ME: goog.getMsg 'Me'
  @MSG_NEW_SONG: goog.getMsg 'New Song'
  @MSG_NOT_FOUND: goog.getMsg 'Page Not Found'
  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs'
  @MSG_SONGS: goog.getMsg 'Songs'
  @MSG_TRASH: goog.getMsg 'Trash'

  get: ->
    switch @routes.active
      when @routes.about then Title.MSG_ABOUT
      when @routes.home then Title.MSG_HOME
      when @routes.songs then Title.MSG_SONGS
      when @routes.recentlyUpdatedSongs then Title.MSG_RECENTLY_UPDATED_SONGS
      when @routes.me then Title.MSG_ME
      when @routes.song then @getSongTitle @songsStore.songsByUrl[0]
      when @routes.mySong, @routes.editSong
        song = @userStore.songByRoute @routes.active
        return Title.MSG_NOT_FOUND if !song
        title = @getSongTitle song
        switch @routes.active
          when @routes.mySong then title
          when @routes.editSong then Title.MSG_EDIT + title
      when @routes.newSong then Title.MSG_NEW_SONG
      when @routes.trash then Title.MSG_TRASH
      else Title.MSG_NOT_FOUND

  getSongTitle: (song) ->
    Title.MSG_SONG = goog.getMsg '{$name} - {$artist}',
      name: song.getDisplayName()
      artist: song.getDisplayArtist()
