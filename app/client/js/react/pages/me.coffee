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
    {a} = touch.none 'a'

    @component = React.createClass

      render: ->
        user = userStore.user
        publishedSongs = for id, url of userStore.publishedSongs
          href = routes.myPublishedSongUrl id
          li key: id,
            a href: href, location.host + href

        div className: 'page',
          p {}, @getWelcomeMessage user.displayName
          img src: user.thirdPartyUserData.picture.data.url
          if publishedSongs.length
            div {},
              p {}, 'Published songs:'
              ul {}, publishedSongs
          div {}, login.component {}

      getWelcomeMessage: (displayName) ->
        Me.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$displayName}.',
          displayName: displayName
