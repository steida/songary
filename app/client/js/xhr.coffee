goog.provide 'app.Xhr'

goog.require 'app.errors.Error'
goog.require 'goog.Promise'
goog.require 'goog.labs.net.xhr'

class app.Xhr

  ###*
    @constructor
  ###
  constructor: ->
    @createHttpMethods_()

  @XHR_OPTIONS:
    headers:
      'Content-Type': 'application/json;charset=utf-8'

  @MSG_MUST_BE_ONLINE: goog.getMsg 'For this action you have to be connected.
    Check your internet connection please.'

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
    if !navigator.onLine
      return goog.Promise.reject new app.errors.Error Xhr.MSG_MUST_BE_ONLINE

    goog.labs.net.xhr
      .send method, url, JSON.stringify(json), Xhr.XHR_OPTIONS
      .then (xhr) -> JSON.parse xhr.responseText
