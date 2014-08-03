goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.react.Touch} touch
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (touch, usersStore) ->
    {button} = touch.none 'button'

    @create = React.createClass
      render: ->
        button
          disabled: true
          onPointerUp: @onButtonPointUp
        , @getButtonLabel()

      onButtonPointUp: (e) ->
        # if usersStore.isLogged()
        #   usersStore.logout()
        # else
        #   usersStore.loginViaFacebook()

      getButtonLabel: ->
        if usersStore.isLogged()
          Login.MSG_LOGOUT = goog.getMsg 'Logout {$displayName}',
            'displayName': usersStore.user.displayName
        else
          Login.MSG_LOGIN_WITH_FACEBOOK = goog.getMsg 'Log in with Facebook'