suite 'app.songs.Store', ->

  Store = app.songs.Store
  store = null

  setup ->
    store = new Store

  validSong = ->
    validate: -> []

  invalidSong = ->
    validate: -> ['error']

  suite 'all', ->
    test 'should return empty array', ->
      songs = store.all()
      assert.deepEqual songs, []

  suite 'save', ->
    test 'should save valid model', (done) ->
      song = validSong()
      store.listen 'change', ->
        assert.deepEqual store.all(), [song]
        done()
      errors = store.save song
      assert.deepEqual errors, []

    test 'should not save invalid model', ->
      song = invalidSong()
      changeDispatched = false
      store.listen 'change', -> changeDispatched = true
      errors = store.save song
      assert.isFalse changeDispatched
      assert.deepEqual errors, song.validate()

  suite 'delete', ->
    test 'should delete model', (done) ->
      song = validSong()
      store.save song
      store.listen 'change', ->
        assert.deepEqual store.all(), []
        done()
      store.delete song