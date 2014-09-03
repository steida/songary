goog.provide 'app.react.pages.Me'

class app.react.pages.Me

  ###*
    @param {app.user.Store} userStore
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (userStore, login) ->
    {div,p,img,div} = React.DOM

    @component = React.createClass

      render: ->
        user = userStore.user

        div className: 'page',
          p {}, @getWelcomeMessage user.displayName
          img src: user.thirdPartyUserData.picture.data.url
          div {}, login.component {}

      getWelcomeMessage: (displayName) ->
        Me.MSG_WELCOME_MESSAGE = goog.getMsg 'Hi, {$displayName}.',
          displayName: displayName
