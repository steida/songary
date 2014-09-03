goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.user.Store} userStore
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (userStore, login) ->
    {footer,p} = React.DOM

    @component = React.createClass
      render: ->
        footer {},
          login.component {} if !userStore.isLogged()
          p {}, 'Songary © 2014'
