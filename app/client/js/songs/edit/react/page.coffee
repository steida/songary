goog.provide 'app.songs.edit.react.Page'

goog.require 'goog.ui.Textarea'

class app.songs.edit.react.Page

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {div,form,fieldset,legend,input,textarea} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'new-song',
          form null,
            input
              autoFocus: true
              name: 'name'
              placeholder: Page.MSG_SONG_NAME
              type: 'text'
            textarea
              name: 'chordpro'
              placeholder: Page.MSG_WRITE_LYRICS_HERE
              ref: 'chordpro'

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['chordpro'].getDOMNode()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg 'Write lyrics here'