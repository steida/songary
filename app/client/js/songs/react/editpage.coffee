goog.provide 'app.songs.react.EditPage'

class app.songs.react.EditPage

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'new-song', 'New song here'