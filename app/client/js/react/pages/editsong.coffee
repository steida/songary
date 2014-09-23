goog.provide 'app.react.pages.EditSong'

goog.require 'app.songs.Song'
goog.require 'goog.array'
goog.require 'goog.dom'
goog.require 'goog.labs.userAgent.browser'
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
                onPaste: @onLyricsPaste
                onChange: @onFieldChange
                placeholder: EditSong.MSG_WRITE_LYRICS_HERE
                ref: 'lyrics'
                value: song.lyrics
              if userStore.isLogged()
                @renderLocalHistory song
              if !song.inTrash
                p className: 'help',
                  a
                    href: 'http://linkesoft.com/songbook/chordproformat.html'
                    target: '_blank'
                  , EditSong.MSG_HOW_TO_WRITE_LYRICS
                  ', or find some on '
                  a
                    href: 'http://www.ultimate-guitar.com/'
                    target: '_blank'
                  , 'ultimate-guitar.com'
                  ' or '
                  a
                    href: 'http://www.supermusic.sk/'
                    target: '_blank'
                  , 'supermusic.sk'
                  '.'
            nav {},
              if editMode
                button
                  className: "btn btn-#{if song.inTrash then 'default' else 'danger'}"
                  onPointerUp: @onToggleDeleteButtonPointerUp
                  type: 'button'
                , if song.inTrash then EditSong.MSG_RESTORE else EditSong.MSG_DELETE
              else
                button className: 'btn btn-default', EditSong.MSG_CREATE_NEW_SONG
              if editMode && !song.inTrash then [
                button
                  className: 'btn btn-default'
                  key: 'publish'
                  onPointerUp: @onPublishPointerUp
                  type: 'button'
                , EditSong.MSG_PUBLISH
                if song.isPublished()
                  button
                    className: 'btn btn-default'
                    key: 'unpublish'
                    onPointerUp: @onUnpublishPointerUp
                    type: 'button'
                  , EditSong.MSG_UNPUBLISH
              ]
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
          if lyricsHistoryShown
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
        if song.inTrash
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

      onLyricsPaste: (e) ->
        @tryParsePastedHtmlWithChordsAndAllThatStuff e

      tryParsePastedHtmlWithChordsAndAllThatStuff: (e) ->
        # IE doesn't support e.clipboardData.getData 'text/html'
        # TODO: Check IE11, IE12, IE13...
        return if goog.labs.userAgent.browser.isIE()

        try
          # Returns empty string for data without HTML.
          html = e.clipboardData.getData 'text/html'
        catch e
          # TODO: Log to server.

        if html
          # Prevent pasting plain text when we have rich HTML.
          e.preventDefault()
          previousLyrics = e.target.value
          lyrics = if previousLyrics.trim()
            if goog.string.endsWith previousLyrics, '\n'
              previousLyrics
            else
              previousLyrics + '\n'
          else
            ''
          # Append because app model doesn't define caret position.
          # Can I read caret position?
          lyrics += @parsePastedHtml html
          userStore.updateSong song, 'lyrics', lyrics

      parsePastedHtml: (html) ->
        node = goog.dom.htmlToDocumentFragment html
        # Convert sup elements to chords. Used by supermusic.sk for example.
        sups = node.querySelectorAll 'sup'
        if sups.length > 0
          for sup in goog.array.toArray sups
            chord = sup.textContent
            textNode = document.createTextNode "[#{chord}]"
            sup.parentNode.replaceChild textNode, sup
        # Preserve new lines.
        for br in node.querySelectorAll 'br'
          newLine = document.createTextNode '\n'
          br.parentNode.replaceChild newLine, br
        # Flatten all other elements.
        for child in node.querySelectorAll '*'
          goog.dom.flattenElement child
        node.textContent.trim()

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
