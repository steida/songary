goog.provide 'app.react.pages.Trash'

class app.react.pages.Trash

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, userStore, touch) ->
    {div,ul,li,nav,button} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        allSongs = userStore.songsSortedByName()
        deletedSongs = allSongs.filter (song) -> song.inTrash

        div className: 'page',
          ul className: 'deleted-songs', deletedSongs.map (song) ->
            li key: song.id,
              a href: routes.editSong.url(song),
                "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          nav {},
            button
              className: 'btn btn-danger'
              onClick: @onEmptyTrashClick
            , Trash.MSG_EMPTY_TRASH

      onEmptyTrashClick: ->
        if confirm Trash.MSG_ARE_YOU_SURE
          userStore.deleteSongsInTrash()
          routes.home.redirect()
          return

  @MSG_EMPTY_TRASH: goog.getMsg 'Empty Trash'
  @MSG_ARE_YOU_SURE: goog.getMsg 'Are you sure you want to permanently erase all songs in trash?'
