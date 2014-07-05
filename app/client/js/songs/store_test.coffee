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

  suite 'add', ->
    test 'should add valid model', (done) ->
      song = validSong()
      store.listen 'change', ->
        assert.deepEqual store.all(), [song]
        done()
      errors = store.add song
      assert.deepEqual errors, []

    test 'should not add invalid model', ->
      song = invalidSong()
      changeDispatched = false
      store.listen 'change', -> changeDispatched = true
      errors = store.add song
      assert.isFalse changeDispatched
      assert.deepEqual errors, song.validate()

  suite 'delete', ->
    test 'should delete model', (done) ->
      song = validSong()
      store.add song
      store.listen 'change', ->
        assert.deepEqual store.all(), []
        done()
      store.delete song

  suite 'songByRoute', ->
    test 'should return added song looked up with params', ->
      song = urlArtist: 'a', urlName: 'b', validate: -> []
      store.add song
      songByRoute = store.songByRoute params: urlArtist: 'a', urlName: 'b'
      assert.deepEqual songByRoute, song

    test 'should return null', ->
      assert.isNull store.songByRoute params: urlArtist: 'a', urlName: 'b'

  suite 'contains', ->
    test 'should check if song with the same name and artist is in store', ->
      song = new app.songs.Song 'a', 'b', 'lala'
      assert.isFalse store.contains song
      store.add song
      assert.isTrue store.contains song

  suite 'newSong', ->
    test 'should be defined on store', ->
      assert.instanceOf store.newSong, app.songs.Song

  suite 'setNewSong', ->
    test 'should set new song property', (done) ->
      store.listen 'change', ->
        assert.equal store.newSong.name, 'Name'
        assert.equal store.newSong.urlName, 'name'
        done()
      store.setNewSong 'name', 'Name'

  suite 'addNewSong', ->
    test 'should add valid new song', ->
      song = validSong()
      store.newSong = song
      errors = store.addNewSong()
      assert.equal store.all()[0], song
      assert.isFalse store.newSong == song
      assert.deepEqual errors, []

    test 'should not add invalid new song', ->
      song = invalidSong()
      store.newSong = song
      errors = store.addNewSong()
      assert.equal store.all().length, 0
      assert.isTrue store.newSong == song
      assert.deepEqual errors, ['error']