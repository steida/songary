goog.provide 'app.home.index.react.Page'

class app.home.index.react.Page

  ###*
    @param {app.Routes} routes
    @param {app.react.TouchAnchor} touchAnchor
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (routes, touchAnchor, songsStore) ->
    {div,ul,li} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'home',
          touchAnchor.create href: routes.newSong.createUrl(),
            Page.MSG_FOO
          ul null, songsStore.all().map (song) ->
            li key: song.name, song.name


  ###*
    @desc app.home.index.react.Page
  ###
  @MSG_FOO: goog.getMsg 'create new song'