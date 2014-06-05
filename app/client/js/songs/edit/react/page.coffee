goog.provide 'app.songs.edit.react.Page'

class app.songs.edit.react.Page

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'new-song', Page.MSG_NEW_SONG_HERE

  ###*
    @desc app.songs.edit.react.Page
  ###
  @MSG_NEW_SONG_HERE: goog.getMsg 'New song here'