goog.provide 'app.react.pages.Trash'

class app.react.pages.Trash

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, userStore, touch) ->
    {div,h1,ul,li} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        allSongs = userStore.songsSortedByName()
        deletedSongs = allSongs.filter (song) -> song.inTrash

        div className: 'page',
          h1 {}, Trash.MSG_TITLE
          ul className: 'deleted-songs', deletedSongs.map (song) ->
            li key: song.id,
              a href: routes.editSong.url(song),
                "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          a
            className: 'btn btn-default'
            href: routes.home.url()
          , Trash.MSG_HOME_LINK_LABEL

  @MSG_TITLE: goog.getMsg 'Trash'
  @MSG_HOME_LINK_LABEL: goog.getMsg 'Back to songs.'
