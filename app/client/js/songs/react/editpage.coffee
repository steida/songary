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
        div className: 'new-song', EditPage.MSG_NEW_SONG_HERE

  ###*
    @desc app.songs.react.EditPage
  ###
  @MSG_NEW_SONG_HERE: goog.getMsg 'New song here'