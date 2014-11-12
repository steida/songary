goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.users.Store} usersStore
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (usersStore, login) ->
    {footer, p} = React.DOM

    @component = React.createFactory React.createClass
      render: ->
        footer {},
          login.component {} if !usersStore.isLogged()
          p {}, 'Songary © 2014'
