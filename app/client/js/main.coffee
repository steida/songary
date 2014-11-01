goog.provide 'app.main'

goog.require 'app.DiContainer'

# Remember to use the same defines for dev and production (defined in gulpfile).
CLOSURE_UNCOMPILED_DEFINES =
  'goog.array.ASSUME_NATIVE_FUNCTIONS': true
  'goog.dom.ASSUME_STANDARDS_MODE': true
  'goog.json.USE_NATIVE_JSON': true
  'goog.style.GET_BOUNDING_CLIENT_RECT_ALWAYS_EXISTS': true

###*
  @param {Object} data Server side data. Useful for config, preload, whatever.
###
app.main = (data) ->

  container = new app.DiContainer
  container.configure
    resolve: app.FrontPage
    with: element: document.body
  container.resolveApp()

goog.exportSymbol 'app.main', app.main
