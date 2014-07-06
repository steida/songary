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
          form
            # PATTERN(steida): React forms events bubbles, which is nice.
            # onFormChange handler immediately stores form state for us.
            onChange: @onFormChange
            onSubmit: @onFormSubmit
            ref: 'form'
            role: 'form'
          ,
            div className: 'form-group',
              input
                autoFocus: true
                className: 'form-control'
                # PATTERN(steida): Don't use props for app model. Use stores.
                # Stores should be prefetched by app.Storage.
                defaultValue: store.newSong.name
                name: 'name'
                placeholder: EditSong.MSG_SONG_NAME
                # PATTERN(steida): type text is default, so we need to write it.
                # type: 'text'
            div className: 'form-group',
              input
                className: 'form-control'
                defaultValue: store.newSong.artist
                name: 'artist'
                placeholder: EditSong.MSG_SONG_ARTIST
            div className: 'form-group',
              textarea
                className: 'form-control'
                defaultValue: store.newSong.lyrics
                name: 'lyrics'
                placeholder: EditSong.MSG_WRITE_LYRICS_HERE
                ref: 'lyrics'
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

      onFormChange: (e) ->
        # PATTERN(steida): All changes are immediatelly stored into stores.
        # Stores are asap synced with local/rest storages.
        store.setNewSong e.target.name, e.target.value

      onFormSubmit: (e) ->
        e.preventDefault()
        @addSong()

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