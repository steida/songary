goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Routes} routes
    @param {app.react.Gesture} gesture
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (routes, gesture, userStore) ->
    {button} = React.DOM

    @component = React.createClass

      render: ->
        null
        # button
        #   className: 'btn btn-default'
        #   # Click because popup needs it.
        #   onClick: @onClick
        # , if userStore.isLogged() then Login.MSG_LOGOUT else Login.MSG_LOGIN

      # onClick: ->
      #   if userStore.isLogged()
      #     routes.home.redirect()
      #     firebase.logout()
      #   else
      #     # TODO: Add more options.
      #     firebase.loginViaFacebook()

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
