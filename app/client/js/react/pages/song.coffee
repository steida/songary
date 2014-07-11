goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'
goog.require 'goog.dom.ViewportSizeMonitor'
goog.require 'goog.dom.classlist'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.songs.Store} store
    @param {app.react.pages.NotFound} notFound
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (store, notFound, routes) ->
    {div,h1,h2,a} = React.DOM

    @create = React.createClass

      ###* @type {goog.dom.ViewportSizeMonitor} ###
      viewportMonitor: null

      render: ->
        return notFound.create null if !store.song

        div className: 'song',
          # TODO(steida): Show details on tap/click.
          # h2 null, "#{store.song.name} [#{store.song.artist}]"
          div
            className: 'lyrics'
            dangerouslySetInnerHTML: '__html': @lyricsHtml()
            ref: 'lyrics'
          # a
          #   className: 'btn btn-default'
          #   href: routes.editMySong.createUrl(store.song),
          # , Song.MSG_EDIT_SONG

      lyricsHtml: ->
        goog.string
          .htmlEscape store.song.lyrics
          .replace /\[([^\]]+)\]/g, (str, chord) ->
            "<sup>#{chord}</sup>"

      componentDidMount: ->
        goog.dom.classlist.add document.body, 'active-song'
        @setLyricsMaxFontSize()
        @viewportMonitor = new goog.dom.ViewportSizeMonitor
        @viewportMonitor.listen 'resize', => @setLyricsMaxFontSize()

      componentWillUnmount: ->
        goog.dom.classlist.remove document.body, 'active-song'
        @viewportMonitor.dispose()

      componentDidUpdate: ->
        # TODO(steida): Implement fontSize increase and decrease.
        # @setLyricsMaxFontSize()

      ###*
        Detect max lyrics fontSize to fit into screen.
        TODO(steida): Describe strategies.
      ###
      setLyricsMaxFontSize: ->
        el = @refs['lyrics'].getDOMNode()
        originalVisibility = el.style.visibility
        el.style.visibility = 'hidden'
        fontSize = 6
        while fontSize != 55
          el.style.fontSize = fontSize + 'px'
          scrollbarIsVisible =
            el.scrollHeight > el.offsetHeight ||
            el.scrollWidth > el.offsetWidth
          if scrollbarIsVisible
            el.style.fontSize = (fontSize - 1) + 'px'
            break
          fontSize++
        el.style.visibility = originalVisibility

  @MSG_EDIT_SONG: goog.getMsg 'Edit song'

  name: 'song'