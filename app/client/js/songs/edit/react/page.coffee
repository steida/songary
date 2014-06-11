goog.provide 'app.songs.edit.react.Page'

goog.require 'app.songs.Song'
goog.require 'este.dom'
goog.require 'goog.ui.Textarea'

class app.songs.edit.react.Page

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} store
    @constructor
  ###
  constructor: (routes, store) ->

    @create = React.createClass

      render: ->
        {div,form,input,textarea,button,a} = React.DOM

        div className: 'new-song',
          form onSubmit: @onFormSubmit, ref: 'form',
            input
              autoFocus: true
              name: 'name'
              placeholder: Page.MSG_SONG_NAME
              ref: 'name'
              type: 'text'
            textarea
              name: 'chordpro'
              placeholder: Page.MSG_WRITE_LYRICS_HERE
              ref: 'chordpro'
            button
              type: 'submit'
            , Page.MSG_CREATE_NEW_SONG
          a
            href: 'http://linkesoft.com/songbook/chordproformat.html'
            target: '_blank'
          , Page.MSG_HOW_TO_WRITE_LYRICS

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['chordpro'].getDOMNode()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFormSubmit: (e) ->
        e.preventDefault()
        @addSong()

      addSong: ->
        form = @refs['form'].getDOMNode()
        data = este.dom.serializeForm form
        song = new app.songs.Song data.name, data.chordpro
        errors = store.add song
        if errors.length
          field = form.elements[errors[0].prop]
          field.focus()
          return
        routes.home.redirect()

  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg 'Write lyrics here'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Create new song'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'