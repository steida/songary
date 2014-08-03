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

  suite 'newSong', ->
    test 'should be defined on store', ->
      assert.instanceOf store.newSong, app.songs.Song

  suite 'addNewSong', ->
    test 'should add valid new song', (done) ->
      song = validSong()
      store.listen 'change', ->
        assert.equal store.all()[0], song
        assert.isFalse store.newSong == song
        done()
      store.newSong = song
      errors = store.addNewSong()
      assert.deepEqual errors, []

    test 'should not add invalid new song', ->
      song = invalidSong()
      changeDispatched = false
      store.listen 'change', -> changeDispatched = true
      store.newSong = song
      errors = store.addNewSong()
      assert.equal store.all().length, 0
      assert.isTrue store.newSong == song
      assert.deepEqual errors, ['error']
      assert.isFalse changeDispatched

  suite 'delete', ->
    test 'should delete song', (done) ->
      song = store.newSong = validSong()
      store.addNewSong()
      store.listen 'change', ->
        assert.deepEqual store.all(), []
        done()
      store.delete song

  suite 'mySongByRoute', ->
    test 'should return added song looked up with params', ->
      song = store.newSong = urlArtist: 'a', urlName: 'b', validate: -> []
      store.addNewSong()
      mySongByRoute = store.mySongByRoute params: urlArtist: 'a', urlName: 'b'
      assert.deepEqual mySongByRoute, song

    test 'should return null', ->
      assert.isNull store.mySongByRoute params: urlArtist: 'a', urlName: 'b'

  suite 'updateSong', ->
    test 'should udpate song', (done) ->
      store.listen 'change', ->
        assert.equal store.newSong.name, 'Name'
        assert.equal store.newSong.urlName, 'name'
        done()
      store.updateSong store.newSong, 'name', 'Name'

  suite 'contains', ->
    test 'should check if song with the same name and artist is in store', ->
      song = store.newSong = store.instanceFromJson app.songs.Song,
        name: 'a'
        artist: 'b'
        lyrics: 'c'
      assert.isFalse store.contains song
      store.addNewSong()
      assert.isTrue store.contains song