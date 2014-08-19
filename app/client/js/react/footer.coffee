goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (login) ->
    {footer} = React.DOM

    @component = React.createClass
      render: ->
        footer {},
          login.component {}
