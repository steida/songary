goog.provide 'app.Xhr'

goog.require 'goog.Promise'
goog.require 'goog.labs.net.xhr'

class app.Xhr

  ###*
    TODO: Check connection etc.
    @param {app.Error} error
    @constructor
  ###
  constructor: (@error) ->
    @createHttpMethods_()

  @XHR_OPTIONS:
    headers:
      'Content-Type': 'application/json;charset=utf-8'

  createHttpMethods_: ->
    @delete = @send.bind @, 'DELETE'
    @get = @send.bind @, 'GET'
    @patch = @send.bind @, 'PATCH'
    @post = @send.bind @, 'POST'
    @put = @send.bind @, 'PUT'

  ###*
    @param {string} method
    @param {string} url
    @param {Object=} json
    @return {!goog.Promise}
  ###
  send: (method, url, json) ->
    # TODO: Throw error or ignore pending requests with the same args.
    data = JSON.stringify json
    goog.labs.net.xhr
      .send method, url, data, Xhr.XHR_OPTIONS
      .thenCatch @error.handle
