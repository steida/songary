goog.provide 'app.react.pages.NotFound'

class app.react.pages.NotFound

  ###*
    @constructor
  ###
  constructor: ->
    {div,h1,p} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'notfound',
          h1 null, "This page isn't available"
          p null, "The link may be broken, or the page may have been removed."