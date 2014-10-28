goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (actions, routes, usersStore) ->
    {button} = React.DOM

    @component = React.createFactory React.createClass

      getInitialState: ->
        disabled: false

      render: ->
        button
          className: 'btn btn-default'
          onClick: @onClick
          disabled: @state.disabled
        , if usersStore.isLogged() then Login.MSG_LOGOUT else Login.MSG_LOGIN

      # Always native click, because most modern browsers block pop-up
      # windows unless they are invoked by direct user action.
      onClick: ->
        @setState disabled: true
        if usersStore.isLogged()
          actions.logout().then -> routes.home.redirect()
        else
          actions.login().then => @setState disabled: false

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
