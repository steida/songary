goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.user.Store} userStore
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (routes, touch, userStore, firebase) ->
    {button} = touch.none 'button'

    @component = React.createClass

      render: ->
        if userStore.isLogged()
          @renderButton @logout, Login.MSG_LOGOUT
        else
          @renderButton @login, Login.MSG_LOGIN

      renderButton: (onPointerUp, label) ->
        button className: 'btn btn-default', onPointerUp: onPointerUp, label

      logout: ->
        routes.home.redirect()
        firebase.logout()

      login: ->
        # TODO: Add more options.
        firebase.loginViaFacebook()

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
