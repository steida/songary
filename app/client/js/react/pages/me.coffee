goog.provide 'app.react.pages.Me'

class app.react.pages.Me

  ###*
    @param {app.Routes} routes
    @param {app.react.Login} login
    @param {este.react.Gesture} gesture
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (routes, login, gesture, usersStore) ->
    {div, p, img, ul, li, nav} = React.DOM
    {a, button} = gesture.none 'a', 'button'

    @component = React.createFactory React.createClass

      render: ->
        fid = usersStore.user.providers.facebook.id
        publishedSongs = usersStore.songs.filter (song) -> song.isPublished()

        div className: 'page',
          p {}, @getWelcomeMessage usersStore.user.name
          img
            className: 'user-picture'
            src: "http://graph.facebook.com/#{fid}/picture?type=normal&height=100"
          nav {},
            login.component {}
            button
              className: 'btn btn-default'
              onTap: @onBackupTap
              type: 'button'
            , Me.MSG_BACKUP
          if publishedSongs.length
            div {},
              p {}, Me.MSG_PUBLISHED_SONGS
              ul {}, publishedSongs.map (song) ->
                href = routes.song.url song
                li key: song.id,
                  a href: href, location.host + href

      getWelcomeMessage: (name) ->
        Me.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$name}.',
          name: name

      onBackupTap: ->
        data = JSON.stringify usersStore.songs
        anchor = document.createElement 'a'
        href = 'data:text/plain;charset=utf-8,' + encodeURIComponent data
        anchor.setAttribute 'href', href
        anchor.setAttribute 'download', 'songs.json'
        anchor.click()

  @MSG_PUBLISHED_SONGS: goog.getMsg 'Your published songs:'
  @MSG_BACKUP: goog.getMsg 'Download Your Songs'
