goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @param {app.Title} appTitle
    @constructor
  ###
  constructor: (router, routes, @reactApp, @element, @appTitle) ->
    routes.addToEste router
    routes.listen este.Routes.EventType.CHANGE, (e) => @syncUi()
    router.start()

  ###*
    @protected
  ###
  syncUi: ->
    if @component
      @component.forceUpdate()
    else
      @component = React.renderComponent @reactApp.create(), @element
    document.title = @appTitle.get()