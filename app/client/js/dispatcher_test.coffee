suite 'app.Dispatcher', ->

  Dispatcher = app.Dispatcher
  dispatcher = null

  setup ->
    error = handle: ->
    dispatcher = new Dispatcher error

  suite 'register', ->
    test 'should throw error if arg is not function', ->
      assert.throws ->
        dispatcher.register 'foo'
      , 'Assertion failed: Expected function but got string: foo'

  suite 'unregister', ->
    test 'should throw error if id was not registered', ->
      assert.throws ->
        dispatcher.unregister 123
      , 'Assertion failed: `123` does not map to a registered callback.'

  suite 'dispatch', ->
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

    test 'should throw error if action is not string', ->
      assert.throws ->
        dispatcher.dispatch 1
      , 'Assertion failed: Expected string but got number: 1'

    test 'should throw error if payload is not object', ->
      assert.throws ->
        dispatcher.dispatch 'foo', 1
      , 'Assertion failed: Expected object but got number: 1'

    test 'should throw error if called during dispatching', (done) ->
      dispatcher = new Dispatcher handle: ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.dispatch 'action', {}
        , 'Assertion failed: Cannot dispatch in the middle of a dispatch.'
        done()
      dispatcher.dispatch 'action', {}

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

    test 'should throw error if not called during dispatching', ->
      assert.throws ->
        dispatcher.waitFor [1]
      , 'Assertion failed: Must be invoked while dispatching.'

    test 'should throw error if indexes is not an array', (done) ->
      dispatcher = new Dispatcher handle: ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.waitFor 123
        , "Assertion failed: Expected array but got number: 123"
        done()
      dispatcher.dispatch 'action', {}

    test 'should throw error if callback is unknown', (done) ->
      dispatcher = new Dispatcher handle: ->
      dispatcher.register (action, payload) ->
        assert.throws ->
          dispatcher.waitFor [123]
        , 'Assertion failed: `123` does not map to a registered callback'
        done()
      dispatcher.dispatch 'action', {}
