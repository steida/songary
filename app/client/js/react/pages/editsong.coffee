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
    {div,form,input,textarea,p,button} = React.DOM
    {a} = touch.none 'a'

    song = null
    editMode = false

    @component = React.createClass

      render: ->
        song = @props.song ? userStore.newSong
        editMode = !!@props.song

        div className: 'page',
          form onSubmit: @onFormSubmit, ref: 'form', role: 'form',
            div className: 'form-group',
              input
                autoComplete: false
                autoFocus: !editMode
                className: 'form-control'
                disabled: song.inTrash
                name: 'name'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_NAME
                value: song.name
            div className: 'form-group',
              input
                autoComplete: false
                className: 'form-control'
                disabled: song.inTrash
                name: 'artist'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_ARTIST
                value: song.artist
            div className: 'form-group',
              textarea
                className: 'form-control'
                disabled: song.inTrash
                name: 'lyrics'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_WRITE_LYRICS_HERE
                ref: 'lyrics'
                value: song.lyrics
              p className: 'help-block',
                a
                  href: 'http://linkesoft.com/songbook/chordproformat.html'
                  target: '_blank'
                , EditSong.MSG_HOW_TO_WRITE_LYRICS
            div className: 'form-group horizontal',
              button
                className: 'btn btn-default'
              , if editMode
                  EditSong.MSG_BACK_TO_SONGS
                else
                  EditSong.MSG_CREATE_NEW_SONG
              editMode && button
                className: 'btn btn-danger'
                onClick: @onToggleDeleteButtonClick
                type: 'button'
              , if song.inTrash then EditSong.MSG_RESTORE else EditSong.MSG_DELETE

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['lyrics'].getDOMNode()

      componentDidUpdate: ->
        # For update from other devices. Locally it's not needed.
        @chordproTextarea_.resize()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFieldChange: (e) ->
        userStore.updateSong song, e.target.name, e.target.value

      onFormSubmit: (e) ->
        e.preventDefault()
        @saveSong()

      saveSong: ->
        errors = if editMode
          song.validate()
        else
          userStore.addNewSong()
        # TODO: Reusable helper/mixin/whatever.
        if errors.length
          alert errors[0].message
          field = this.refs['form'].getDOMNode().elements[errors[0].prop]
          field.focus() if field
          return
        routes.home.redirect()

      onToggleDeleteButtonClick: ->
        userStore.trashSong song, !song.inTrash
        routes.home.redirect()

  # PATTERN: String localization. Remember, every string has to be wrapped with
  # goog.getMsg method.
  @MSG_BACK_TO_SONGS: goog.getMsg 'Back to Songs'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Add new song'
  @MSG_DELETE: goog.getMsg 'Delete'
  @MSG_RESTORE: goog.getMsg 'Restore'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'
  @MSG_SONG_ARTIST: goog.getMsg 'Artist (or band)'
  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg '[F]Michelle [Bmi7]ma belle...'
