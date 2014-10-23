goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (actions, routes, userStore) ->
    {button} = React.DOM

    @component = React.createFactory React.createClass

      getInitialState: ->
        disabled: false

      render: ->
        button
          className: 'btn btn-default'
          onClick: @onClick
          disabled: @state.disabled
        , if userStore.isLogged() then Login.MSG_LOGOUT else Login.MSG_LOGIN

      # Always native click, because most modern browsers block pop-up
      # windows unless they are invoked by direct user action.
      onClick: ->
        @setState disabled: true
        if userStore.isLogged()
          actions.logout().then -> routes.home.redirect()
        else
          actions.login()

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
