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
    {div,p,img,ul,li} = React.DOM
    {a} = touch.scroll 'a'

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
          img src: user.thirdPartyUserData.picture.data.url
          if publishedSongs.length
            div {},
              p {}, Me.MSG_PUBLISHED_SONGS
              ul {}, publishedSongs
          div {}, login.component {}

      getWelcomeMessage: (displayName) ->
        Me.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$displayName}.',
          displayName: displayName

  @MSG_PUBLISHED_SONGS: goog.getMsg 'Published songs:'
