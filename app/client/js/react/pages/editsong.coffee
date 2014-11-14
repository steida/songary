goog.provide 'app.react.pages.EditSong'

goog.require 'app.songs.Song'
goog.require 'goog.array'
goog.require 'goog.dom'
goog.require 'goog.dom.selection'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.labs.userAgent.device'
goog.require 'goog.ui.Textarea'

class app.react.pages.EditSong

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.react.YellowFade} yellowFade
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (actions, routes, yellowFade, usersStore, element) ->
    {div, form, input, textarea, p, nav, ol, li, br, a, span, button} = element

    # Why not React state? Because it's not preserved over component life cycle.
    # TODO: Add state =
    editMode = false
    lyricsHistoryChanged = false
    lyricsHistoryShown = false
    previousLyricsHistory = null
    song = null

    @component = React.createFactory React.createClass

      render: ->
        song = @props.song ? usersStore.newSong
        editMode = !!@props.song

        div className: 'page',
          form autoComplete: 'off', onSubmit: @onFormSubmit, ref: 'form', role: 'form',
            div className: 'form-group',
              input
                # AutoFocus on small screen sucks, because it's confusing.
                autoFocus: goog.labs.userAgent.device.isDesktop() && !editMode
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
              # if usersStore.isLogged()
              #   @renderLocalHistory song
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
                  '. Extract chords from '
                  a
                    href: 'http://chordify.net/'
                    target: '_blank'
                  , 'any song'
                  '.'
            nav {},
              if !editMode
                button
                  className: 'btn btn-default'
                , EditSong.MSG_ADD_NEW_SONG
              # if editMode && !song.inTrash then [
              #   button
              #     className: 'btn btn-default'
              #     key: 'publish'
              #     onTap: @onPublishTap
              #     type: 'button'
              #   , EditSong.MSG_PUBLISH
              #   if song.isPublished()
              #     button
              #       className: 'btn btn-default'
              #       key: 'unpublish'
              #       onTap: @onUnpublishTap
              #       type: 'button'
              #     , EditSong.MSG_UNPUBLISH
              # ]
              if editMode
                button
                  className: "btn btn-#{if song.inTrash then 'default' else 'danger'}"
                  onTap: @onSongToggleInTrashTap
                  type: 'button'
                , if song.inTrash then EditSong.MSG_RESTORE else EditSong.MSG_DELETE
            if editMode && song.isPublished()
              p {},
                EditSong.MSG_SONG_WAS_PUBLISHED + ' '
                a
                  href: routes.song.url song
                  ref: 'published-song-link'
                  touchAction: 'none'
                , location.host + routes.song.url song
                '.'

      # renderLocalHistory: (song) ->
      #   lyricsHistory = @getLyricsHistory song
      #
      #   if previousLyricsHistory
      #     lyricsHistoryChanged = previousLyricsHistory.join() != lyricsHistory.join()
      #   previousLyricsHistory = lyricsHistory
      #
      #   return null if !lyricsHistory.length
      #
      #   lyrics = lyricsHistory.map (lyrics) -> li key: lyrics, lyrics
      #   lyrics.reverse()
      #
      #   span className: 'lyrics-history',
      #     button
      #       ref: 'lyrics-history-button'
      #       className: 'btn btn-default ' + if lyricsHistoryShown then 'active' else ''
      #       onTap: @onLyricsHistoryUp
      #       type: 'button'
      #     , EditSong.MSG_LYRICS_HISTORY
      #     if lyricsHistoryShown
      #       div {},
      #         ol {}, lyrics
      #         p {}, EditSong.MSG_LYRICS_HISTORY_P
      #
      # onLyricsHistoryUp: ->
      #   lyricsHistoryShown = !lyricsHistoryShown
      #   @forceUpdate()

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
        actions.setSongProp song, e.target.name, e.target.value

      onFormSubmit: (e) ->
        e.preventDefault()
        return if editMode
        actions.addNewSong()
          .then -> routes.home.redirect()
          .thenCatch (validationError) =>
            # TODO: Add beautiful reusable helper/mixin/whatever.
            error = validationError.errors[0]
            alert error.msg
            field = @refs['form'].getDOMNode().elements[error.props[0]]
            field.focus() if field

      onSongToggleInTrashTap: ->
        actions.setSongInTrash song, !song.inTrash
          .then ->
            if song.inTrash then routes.home.redirect()

      getLyricsHistory: (song) ->
        # usersStore.getSongLyricsLocalHistory song
        #   .filter (lyrics) -> lyrics != song.lyrics

      # onPublishTap: ->
      #   if !usersStore.isLogged()
      #     # TODO: remove alert.
      #     alert EditSong.MSG_LOGIN_TO_PUBLISH
      #     return
      #   songsStore
      #     .publish song
      #     .then => yellowFade.on @refs['published-song-link']
      #
      # onUnpublishTap: ->
      #   return if !confirm EditSong.MSG_ARE_YOU_SURE_UNPUBLISH
      #   songsStore.unpublish song

      onLyricsPaste: (e) ->
        @tryParsePastedHtmlWithChordsAndAllThatStuff e

      tryParsePastedHtmlWithChordsAndAllThatStuff: (e) ->
        # IE doesn't support e.clipboardData.getData 'text/html'
        # TODO: Check IE11, IE12, IE13...
        return if goog.labs.userAgent.browser.isIE()

        # Can be empty string for data without any HTML.
        html = e.clipboardData.getData 'text/html'
        # Do nothing aka let browser to paste plain text.
        return if !html

        e.preventDefault()
        text = @convertPastedHtmlToText html
        target = e.target
        endPoints = goog.dom.selection.getEndPoints target
        before = target.value.substr 0, endPoints[0]
        after = target.value.substr endPoints[1]
        lyrics = before + text + after
        actions.setSongProp song, 'lyrics', lyrics
        # Give a React time to update, setCursorPosition is not destructive so
        # it's ok to use timeout.
        setTimeout ->
          goog.dom.selection.setCursorPosition target, (before + text).length
        , 10

      convertPastedHtmlToText: (html) ->
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
  @MSG_ADD_NEW_SONG: goog.getMsg 'Add New Song'
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
