goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.react.Touch} touch
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (touch, userStore) ->
    {button} = touch.none 'button'

    @create = React.createClass
      render: ->
        button
          disabled: true
          onPointerUp: @onButtonPointUp
        , @getButtonLabel()

      onButtonPointUp: (e) ->
        # if userStore.isLogged()
        #   userStore.logout()
        # else
        #   userStore.loginViaFacebook()

      getButtonLabel: ->
        'Log in with Facebook'
        # if userStore.isLogged()
        #   Login.MSG_LOGOUT = goog.getMsg 'Logout {$displayName}',
        #     'displayName': userStore.user.displayName
        # else
        #   Login.MSG_LOGIN_WITH_FACEBOOK = goog.getMsg 'Log in with Facebook'