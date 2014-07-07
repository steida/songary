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

    @create = React.createClass

      render: ->
        div className: 'new-song',
          form onSubmit: @onFormSubmit, ref: 'form', role: 'form',
            div className: 'form-group',
              input
                autoFocus: true
                className: 'form-control'
                name: 'name'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_NAME
                value: store.newSong.name
            div className: 'form-group',
              input
                className: 'form-control'
                name: 'artist'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_ARTIST
                value: store.newSong.artist
            div className: 'form-group',
              textarea
                className: 'form-control'
                name: 'lyrics'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_WRITE_LYRICS_HERE
                ref: 'lyrics'
                value: store.newSong.lyrics
              a
                href: 'http://linkesoft.com/songbook/chordproformat.html'
                target: '_blank'
              , EditSong.MSG_HOW_TO_WRITE_LYRICS
            div className: 'form-group',
              button
                className: 'btn btn-default'
                type: 'submit'
              , EditSong.MSG_CREATE_NEW_SONG

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['lyrics'].getDOMNode()

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFormSubmit: (e) ->
        e.preventDefault()
        @addSong()

      onFieldChange: (e) ->
        # PATTERN(steida): All changes are immediatelly stored into store.
        # Store is asap synced with local/rest storages.
        store.setNewSong e.target.name, e.target.value

      addSong: ->
        errors = store.addNewSong()
        # TODO: React helper for that.
        if errors.length
          alert errors[0].message
          field = this.refs['form'].getDOMNode().elements[errors[0].prop]
          field.focus() if field
          return
        routes.home.redirect()

  # PATTERN(steida): String localization. Remember, every string has to be
  # wrapped with goog.getMsg method.
  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_SONG_ARTIST: goog.getMsg 'Artist (or band)'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg '[F]Michelle [Bmi7]ma belle...'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Add new song'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'