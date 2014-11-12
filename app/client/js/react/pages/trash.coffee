goog.provide 'app.react.pages.Trash'

class app.react.pages.Trash

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {este.react.Gesture} gesture
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (actions, routes, gesture, usersStore) ->
    {div,ul,li,nav,button} = React.DOM
    {a} = gesture.scroll 'a'

    @component = React.createFactory React.createClass

      render: ->
        allSongs = usersStore.songsSortedByName()
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
        return if !confirm Trash.MSG_ARE_YOU_SURE
        actions.emptySongsTrash()
          .then -> routes.home.redirect()

  @MSG_EMPTY_TRASH: goog.getMsg 'Empty Trash'
  @MSG_ARE_YOU_SURE: goog.getMsg 'Are you sure you want to permanently erase all songs in trash?'
