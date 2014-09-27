suite 'app.Dispatcher', ->

  Dispatcher = app.Dispatcher
  dispatcher = null

  setup ->
    error = handle: ->
    dispatcher = new Dispatcher error

  suite 'dispatcher', ->
    test 'should call registered callback with action and payload', (done) ->
      dispatcher.register (action, payload) ->
        assert.equal action, 'action'
        assert.deepEqual payload, {}
        done()
      dispatcher.dispatch 'action', {}

    test 'should call all registered callbacks and return promise', (done) ->
      called = 0
      dispatcher.register (action, payload) -> called++
      dispatcher.register (action, payload) -> called++
      dispatcher
        .dispatch 'action', {}
        .then (value) ->
          assert.deepEqual value, [{}, {}]
          assert.equal called, 2
          done()

    test 'should call error handle if rejected promise is returned', (done) ->
      handleCalled = false
      error = handle: (reason, action) ->
        assert.equal reason, 'error'
        assert.equal action, 'action'
        handleCalled = true
      dispatcher = new Dispatcher error
      dispatcher.register (action, payload) ->
        assert.deepEqual payload, {}
        goog.Promise.reject 'error'
      dispatcher
        .dispatch 'action', {}
        .thenCatch ->
          assert.isTrue handleCalled
          done()

  suite 'waitFor', ->
    test 'should wait', (done) ->
      called = ''
      indexA = dispatcher.register ->
        dispatcher
          .waitFor [indexB]
          .then -> called += 'a'
      indexB = dispatcher.register ->
        called += 'b'
      dispatcher
        .dispatch 'action', {}
        .then (value) ->
          assert.equal called, 'ba'
          done()
