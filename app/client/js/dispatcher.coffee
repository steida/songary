goog.provide 'app.Dispatcher'

goog.require 'este.Dispatcher'

class app.Dispatcher extends este.Dispatcher

  ###*
    @param {app.ErrorReporter} errorReporter
    @constructor
    @extends {este.Dispatcher}
  ###
  constructor: (@errorReporter) ->
    super()

  ###*
    @override
  ###
  onError: (action, reason) ->
    @errorReporter.report action, reason
