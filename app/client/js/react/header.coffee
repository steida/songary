goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @constructor
  ###
  constructor: ->
    {h1} = React.DOM

    @create = React.createClass

      render: ->
        h1 null, 'Songary'