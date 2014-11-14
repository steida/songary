goog.provide 'app.react.pages.Trash'

class app.react.pages.Trash

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (actions, routes, usersStore, element) ->
    {div, ul, li, nav, button, a} = element

    @component = React.createFactory React.createClass

      render: ->
        allSongs = usersStore.songsSortedByName()
        deletedSongs = allSongs.filter (song) -> song.inTrash

        div className: 'page',
          ul className: 'deleted-songs', deletedSongs.map (song) ->
            li key: song.id,
              a
                href: routes.editSong.url(song)
                touchAction: 'scroll'
              , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          nav {},
            button
              className: 'btn btn-danger'
              onTap: @onEmptyTrashTap
            , Trash.MSG_EMPTY_TRASH

      onEmptyTrashTap: ->
        return if !confirm Trash.MSG_ARE_YOU_SURE
        actions.emptySongsTrash()
          .then -> routes.home.redirect()

  @MSG_EMPTY_TRASH: goog.getMsg 'Empty Trash'
  @MSG_ARE_YOU_SURE: goog.getMsg 'Are you sure you want to permanently erase all songs in trash?'
