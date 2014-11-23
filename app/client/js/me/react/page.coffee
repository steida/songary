goog.provide 'app.me.react.Page'

class app.me.react.Page

  ###*
    @param {app.Routes} routes
    @param {app.users.react.Login} login
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, login, usersStore, element) ->
    {div, p, img, ul, li, nav, a, button} = element

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
              touchAction: 'none'
              type: 'button'
            , Page.MSG_BACKUP
          if publishedSongs.length
            div {},
              p {}, Page.MSG_PUBLISHED_SONGS
              ul {}, publishedSongs.map (song) ->
                href = routes.song.url song
                li key: song.id,
                  a touchAction: 'scroll', href: href, location.host + href

      getWelcomeMessage: (name) ->
        Page.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$name}.',
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
