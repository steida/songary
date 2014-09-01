suite 'app.user.Store', ->

  Store = app.user.Store
  store = null

  setup ->
    store = new Store

  validSong = (props) ->
    song = validate: -> []
    goog.mixin song, props if props
    song

  invalidSong = ->
    validate: -> ['error']

  suite 'songs', ->
    test 'should return empty array', ->
      songs = store.songs
      assert.deepEqual songs, []

  suite 'newSong', ->
    test 'should be defined on store', ->
      assert.instanceOf store.newSong, app.songs.Song

  suite 'addNewSong', ->
    test 'should add valid new song', (done) ->
      song = validSong()
      store.listen 'change', ->
        assert.equal store.songs[0], song
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
      assert.equal store.songs.length, 0
      assert.isTrue store.newSong == song
      assert.deepEqual errors, ['error']
      assert.isFalse changeDispatched

  suite 'trashSong', ->
    test 'should set song inTrash to true', (done) ->
      store.newSong = validSong()
      store.addNewSong()
      store.listen 'change', ->
        assert.isTrue store.songs[0].inTrash
        done()
      store.trashSong store.songs[0], true

  suite 'songById', ->
    test 'should return added song looked up with params', ->
      song = store.newSong = id: 'foo', validate: -> []
      store.addNewSong()
      songById = store.songById 'foo'
      assert.deepEqual songById, song

    test 'should return null', ->
      assert.isNull store.songById 'foo'

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

  suite 'songsSortedByName', ->
    test 'should return songs sorted by name', ->
      store.newSong = validSong name: 'b'
      store.addNewSong()
      store.newSong = validSong name: 'a'
      store.addNewSong()
      sorted = store.songsSortedByName()
      assert.equal sorted[0].name, 'a'
      assert.equal sorted[1].name, 'b'
