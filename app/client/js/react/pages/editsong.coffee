goog.provide 'app.react.pages.EditSong'

goog.require 'app.songs.Song'
goog.require 'goog.ui.Textarea'

class app.react.pages.EditSong

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} store
    @constructor
  ###
  constructor: (routes, store) ->
    {div,form,input,textarea,a,button} = React.DOM

    song = new app.songs.Song

    @create = React.createClass

      render: ->
        div className: 'new-song',
          form onSubmit: @onFormSubmit, ref: 'form',
            input
              autoFocus: true
              onChange: @onFieldChange
              name: 'name'
              placeholder: EditSong.MSG_SONG_NAME
              type: 'text'
              value: song.name
            input
              onChange: @onFieldChange
              name: 'artist'
              placeholder: EditSong.MSG_SONG_ARTIST
              type: 'text'
              value: song.artist
            textarea
              onChange: @onFieldChange
              name: 'lyrics'
              placeholder: EditSong.MSG_WRITE_LYRICS_HERE
              ref: 'lyrics'
              value: song.lyrics
            a
              href: 'http://linkesoft.com/songbook/chordproformat.html'
              target: '_blank'
            , EditSong.MSG_HOW_TO_WRITE_LYRICS
            button
              type: 'submit'
            , EditSong.MSG_CREATE_NEW_SONG

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['lyrics'].getDOMNode()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFieldChange: (e) ->
        song.setProp e.target.name, e.target.value
        @forceUpdate()

      onFormSubmit: (e) ->
        e.preventDefault()
        @addSong()

      addSong: ->
        errors = store.add song
        # TODO: Consider React helper for that.
        if errors.length
          field = this.refs['form'].getDOMNode().elements[errors[0].prop]
          field.focus()
          return
        song = new app.songs.Song
        routes.home.redirect()

  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_SONG_ARTIST: goog.getMsg 'Artist'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg 'Write lyrics here'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Add new song'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'