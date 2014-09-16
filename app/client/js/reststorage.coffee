goog.provide 'app.RestStorage'

goog.require 'goog.Promise'
goog.require 'goog.labs.net.xhr'

class app.RestStorage

  ###*
    @constructor
  ###
  constructor: ->
    @createHttpMethodAliases_()

  createHttpMethodAliases_: ->
    @delete = @send.bind @, 'DELETE'
    @get = @send.bind @, 'GET'
    @patch = @send.bind @, 'PATCH'
    @push = @send.bind @, 'PUSH'
    @put = @send.bind @, 'PUT'

  @XHR_OPTIONS:
    headers:
      'Content-Type': 'application/json;charset=utf-8'

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
      .send method, url, data, RestStorage.XHR_OPTIONS
