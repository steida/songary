goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (actions, routes, usersStore, element) ->
    {button} = element

    @component = React.createFactory React.createClass

      render: ->
        button
          className: 'btn btn-default'
          disabled: actions.isPending app.Actions.LOGIN, app.Actions.LOGOUT
          onClick: @onClick
        , if usersStore.isLogged() then Login.MSG_LOGOUT else Login.MSG_LOGIN

      # Always native click, because most modern browsers block pop-up windows
      # unless they are invoked by direct user action.
      onClick: ->
        if usersStore.isLogged()
          actions.logout().then -> routes.home.redirect()
        else
          actions.login()

  @MSG_LOGOUT: goog.getMsg 'Log Out'
  @MSG_LOGIN: goog.getMsg 'Login with Facebook'
