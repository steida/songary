goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.react.Login} login
    @constructor
  ###
  constructor: (login) ->
    {footer} = React.DOM

    @create = React.createClass

      render: ->
        footer null,
          login.create null