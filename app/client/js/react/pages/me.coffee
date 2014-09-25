goog.provide 'app.react.pages.Me'

class app.react.pages.Me

  ###*
    @param {app.Routes} routes
    @param {app.react.Login} login
    @param {app.react.Touch} touch
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (routes, login, touch, userStore) ->
    {div,p,img,ul,li,nav} = React.DOM
    {a,button} = touch.scroll 'a', 'button'

    @component = React.createClass

      render: ->
        user = userStore.user
        publishedSongs = userStore.songs
          .filter (song) -> song.isPublished()
          .map (song) ->
            href = routes.song.url song
            li key: song.id,
              a href: href, location.host + href

        div className: 'page',
          p {}, @getWelcomeMessage user.displayName
          img className: 'user-picture', src: user.thirdPartyUserData.picture.data.url
          if publishedSongs.length
            div {},
              p {}, Me.MSG_PUBLISHED_SONGS
              ul {}, publishedSongs
          nav {},
            button
              className: 'btn btn-default'
              onPointerUp: @onBackupButtonPointerUp
              type: 'button'
            , Me.MSG_BACKUP
            login.component {}

      getWelcomeMessage: (displayName) ->
        Me.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$displayName}.',
          displayName: displayName

      onBackupButtonPointerUp: ->
        data = JSON.stringify userStore.songs
        anchor = document.createElement 'a'
        anchor.setAttribute 'href', 'data:text/plain;charset=utf-8,' + encodeURIComponent data
        anchor.setAttribute 'download', 'songs.json'
        anchor.click()

  @MSG_PUBLISHED_SONGS: goog.getMsg 'Published songs:'
  @MSG_BACKUP: goog.getMsg 'Backup'
