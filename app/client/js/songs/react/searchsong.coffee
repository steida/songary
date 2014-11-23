goog.provide 'app.songs.react.SearchSong'

goog.require 'goog.async.Delay'
goog.require 'goog.labs.userAgent.device'

class app.songs.react.SearchSong

  ###*
    @param {app.Actions} actions
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (actions, element) ->
    {div, input} = element
    query = ''

    @component = React.createFactory React.createClass

      render: ->
        div className: 'form-group search-song',
          input
            autoFocus: goog.labs.userAgent.device.isDesktop()
            className: element.className 'form-control',
              'pending': actions.isPending app.Actions.SEARCH_SONG
            onChange: @onSearchChange
            placeholder: SearchSong.MSG_SEARCH_FIELD_PLACEHOLDER
            value: query

      onSearchChange: (e) ->
        query = e.target.value.slice 0, SearchSong.SEARCH_QUERY_MAX_LENGTH
        @forceUpdate()
        @delay.start()

      componentDidMount: ->
        @delay = new goog.async.Delay @onDelayAction, 300

      componentWillUnmount: ->
        @delay.dispose()

      onDelayAction: ->
        actions.searchSong query

  @MSG_SEARCH_FIELD_PLACEHOLDER: goog.getMsg 'Search song by name, artist, or lyrics.'
  @SEARCH_QUERY_MAX_LENGTH: 100
