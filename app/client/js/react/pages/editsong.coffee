goog.provide 'app.react.pages.EditSong'

goog.require 'app.songs.Song'
goog.require 'goog.ui.Textarea'

class app.react.pages.EditSong

  ###*
    @param {app.Online} online
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.react.YellowFade} yellowFade
    @param {app.songs.Store} songsStore
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (online, routes, touch, yellowFade, songsStore, userStore) ->
    {div,form,input,textarea,p,nav,ol,li} = React.DOM
    {a,span,button} = touch.none 'a', 'span', 'button'

    # Why not React state? Because it's not preserved over component life cycle.
    editMode = false
    lyricsHistoryChanged = false
    lyricsHistoryShown = false
    previousLyricsHistory = null
    song = null

    @component = React.createClass

      render: ->
        song = @props.song ? userStore.newSong
        editMode = !!@props.song

        div className: 'page',
          form autoComplete: 'off', onSubmit: @onFormSubmit, ref: 'form', role: 'form',
            div className: 'form-group',
              input
                autoFocus: !editMode
                className: 'form-control'
                disabled: song.inTrash
                name: 'name'
                onChange: @onFieldChange
                placeholder: EditSong.MSG_SONG_NAME
                value: song.name
            div className: 'form-group',
              input
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
              userStore.isLogged() &&
                @renderLocalHistory song
              !song.inTrash &&
                p className: 'help-block',
                  a
                    href: 'http://linkesoft.com/songbook/chordproformat.html'
                    target: '_blank'
                  , EditSong.MSG_HOW_TO_WRITE_LYRICS
            nav {},
              if editMode
                button
                  className: "btn btn-#{song.inTrash && 'default' || 'danger'}"
                  onPointerUp: @onToggleDeleteButtonPointerUp
                  type: 'button'
                , if song.inTrash then EditSong.MSG_RESTORE else EditSong.MSG_DELETE
              else
                button className: 'btn btn-default', EditSong.MSG_CREATE_NEW_SONG
              if editMode && !song.inTrash
                button
                  className: 'btn btn-default'
                  onPointerUp: @onPublishPointerUp
                  type: 'button'
                , EditSong.MSG_PUBLISH
              if editMode && song.isPublished()
                button
                  className: 'btn btn-default'
                  onPointerUp: @onUnpublishPointerUp
                  type: 'button'
                , EditSong.MSG_UNPUBLISH
            if editMode && song.isPublished()
              p {},
                EditSong.MSG_SONG_WAS_PUBLISHED + ' '
                a
                  href: routes.song.url song
                  ref: 'published-song-link'
                , location.host + routes.song.url song
                '.'

      renderLocalHistory: (song) ->
        lyricsHistory = @getLyricsHistory song

        if previousLyricsHistory
          lyricsHistoryChanged = previousLyricsHistory.join() != lyricsHistory.join()
        previousLyricsHistory = lyricsHistory

        return null if !lyricsHistory.length

        lyrics = lyricsHistory.map (lyrics) -> li key: lyrics, lyrics
        lyrics.reverse()

        span className: 'lyrics-history',
          button
            ref: 'lyrics-history-button'
            className: 'btn btn-default ' + if lyricsHistoryShown then 'active' else ''
            onPointerUp: @onLyricsHistoryBtnPointerUp
            type: 'button'
          , EditSong.MSG_LYRICS_HISTORY
          lyricsHistoryShown &&
            div {},
              ol {}, lyrics
              p {}, EditSong.MSG_LYRICS_HISTORY_P

      onLyricsHistoryBtnPointerUp: ->
        lyricsHistoryShown = !lyricsHistoryShown
        @forceUpdate()

      componentDidMount: ->
        @chordproTextarea_ = new goog.ui.Textarea ''
        @chordproTextarea_.decorate @refs['lyrics'].getDOMNode()

      componentDidUpdate: ->
        # For update from other devices. Locally it's not needed.
        @chordproTextarea_.resize()
        @doYellowFadeIfHistoryChanged()

      doYellowFadeIfHistoryChanged: ->
        if !lyricsHistoryShown && lyricsHistoryChanged
          yellowFade.on @refs['lyrics-history-button']

      componentWillUnmount: ->
        @chordproTextarea_.dispose()

      onFieldChange: (e) ->
        userStore.updateSong song, e.target.name, e.target.value

      onFormSubmit: (e) ->
        e.preventDefault()
        @saveSong()

      saveSong: ->
        errors = userStore.addNewSong()
        # TODO: Reusable helper/mixin/whatever.
        if errors.length
          alert errors[0].message
          field = this.refs['form'].getDOMNode().elements[errors[0].prop]
          field.focus() if field
          return
        routes.home.redirect()

      onToggleDeleteButtonPointerUp: ->
        userStore.trashSong song, !song.inTrash
        routes.home.redirect()

      getLyricsHistory: (song) ->
        userStore.getSongLyricsLocalHistory song
          .filter (lyrics) -> lyrics != song.lyrics

      onPublishPointerUp: ->
        if !userStore.isLogged()
          alert EditSong.MSG_LOGIN_TO_PUBLISH
          return
        return if !online.check()
        songsStore
          .publish song
          .then => yellowFade.on @refs['published-song-link']

      onUnpublishPointerUp: ->
        return if !confirm EditSong.MSG_ARE_YOU_SURE_UNPUBLISH
        songsStore.unpublish song

  # PATTERN: String localization. Remember, every string has to be wrapped with
  # goog.getMsg method for later string localization.
  @MSG_ARE_YOU_SURE_UNPUBLISH: goog.getMsg 'Are you sure you want to unpublish this song?'
  @MSG_CREATE_NEW_SONG: goog.getMsg 'Add New Song'
  @MSG_DELETE: goog.getMsg 'Delete'
  @MSG_HOW_TO_WRITE_LYRICS: goog.getMsg 'How to write lyrics'
  @MSG_LOGIN_TO_PUBLISH: goog.getMsg 'You must be logged to publish song.'
  @MSG_LYRICS_HISTORY: goog.getMsg 'Lyrics History'
  @MSG_LYRICS_HISTORY_P: goog.getMsg 'This is just MVP version. Formatting, cleaning, merging etc. will be implemented later. For now, you can merge with copy&paste :-P'
  @MSG_PUBLISH: goog.getMsg 'Publish'
  @MSG_RESTORE: goog.getMsg 'Restore'
  @MSG_SONG_ARTIST: goog.getMsg 'Artist (or band)'
  @MSG_SONG_NAME: goog.getMsg 'Song name'
  @MSG_SONG_WAS_PUBLISHED: goog.getMsg 'Song is published at'
  @MSG_UNPUBLISH: goog.getMsg 'Unpublish'
  @MSG_WRITE_LYRICS_HERE: goog.getMsg '[F]Michelle [Bmi7]ma belle...'
