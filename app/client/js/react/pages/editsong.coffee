goog.provide 'app.react.pages.EditSong'

goog.require 'app.songs.Song'
goog.require 'goog.ui.Textarea'

class app.react.pages.EditSong

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, userStore, touch) ->
    {p,div,form,input,textarea,button} = React.DOM
    {a} = touch.none 'a'

    @component = React.createClass

      render: ->
        div className: 'edit-song',
          form onSubmit: @onFormSubmit, ref: 'form', role: 'form',
            div className: 'form-group',
              input
                autoFocus: !@props.editMode
                className: 'form-control'
                name: 'name'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_NAME
                value: @props.song.name
            div className: 'form-group',
              input
                className: 'form-control'
                name: 'artist'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_ARTIST
                value: @props.song.artist
            div className: 'form-group',
              textarea
                className: 'form-control'
                name: 'lyrics'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_WRITE_LYRICS_HERE
                ref: 'lyrics'
                value: @props.song.lyrics
              p className: 'help-block',
                a
                  href: 'http://linkesoft.com/songbook/chordproformat.html'
                  target: '_blank'
                , EditSong.MSG_HOW_TO_WRITE_LYRICS
            div className: 'form-group horizontal',
              button
                className: 'btn btn-default'
              , if @props.editMode
                  EditSong.MSG_BACK_TO_SONGS
                else
                  EditSong.MSG_CREATE_NEW_SONG
              @props.editMode && button
                className: 'btn btn-danger'
                onClick: @onDeleteButtonClick
                type: 'button'
              , EditSong.MSG_DELETE

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['lyrics'].getDOMNode()

      componentDidUpdate: ->
        # For update from other devices. Locally it's not needed.
        @chordproTextarea_.resize()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFieldChange: (e) ->
        userStore.updateSong @props.song, e.target.name, e.target.value

      onFormSubmit: (e) ->
        e.preventDefault()
        @saveSong()

      saveSong: ->
        errors = if @props.editMode then @props.song.validate() else userStore.addNewSong()
        # TODO: Reusable helper/mixin/whatever.
        if errors.length
          alert errors[0].message
          field = this.refs['form'].getDOMNode().elements[errors[0].prop]
          field.focus() if field
          return
        routes.home.redirect()

      onDeleteButtonClick: ->
        return if !confirm EditSong.MSG_DELETE_QUESTION
        userStore.delete @props.song
        routes.home.redirect()

  # PATTERN: String localization. Remember, every string has to be wrapped with
  # goog.getMsg method.
  @MSG_BACK_TO_SONGS: goog.getMsg 'Back to Songs'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Add new song'
  @MSG_DELETE: goog.getMsg 'Delete'
  @MSG_DELETE_QUESTION: goog.getMsg 'Are you sure?'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'
  @MSG_SONG_ARTIST: goog.getMsg 'Artist (or band)'
  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg '[F]Michelle [Bmi7]ma belle...'
