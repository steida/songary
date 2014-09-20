goog.provide 'app.Xhr'

goog.require 'goog.Promise'
goog.require 'goog.labs.net.xhr'

class app.Xhr

  ###*
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
    data = JSON.stringify json
    goog.labs.net.xhr
      .send method, url, data, Xhr.XHR_OPTIONS
      .then (xhr) -> JSON.parse xhr.responseText
      .thenCatch @error.handle
