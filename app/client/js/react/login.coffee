goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Facebook} facebook
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (facebook, routes, userStore) ->
    {button} = React.DOM

    @component = React.createFactory React.createClass

      render: ->
        button
          className: 'btn btn-default'
          # Always native click, because most modern browsers block pop-up
          # windows unless they are invoked by direct user action.
          onClick: @onClick
        , if userStore.isLogged() then Login.MSG_LOGOUT else Login.MSG_LOGIN

      onClick: ->
        if userStore.isLogged()
          facebook.logout()
          routes.home.redirect()
        else
          facebook.login()

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
