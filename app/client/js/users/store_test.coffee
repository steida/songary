suite 'app.users.Store', ->

  Store = app.users.Store
  dispatcher = null
  store = null

  setup ->
    dispatcher = register: ->
    store = new Store dispatcher

  suite 'constructor', ->
    test 'should set default state', ->
      assert.equal store.name, 'users'
      assert.instanceOf store.newSong, app.songs.Song
      assert.isArray store.songs
      assert.instanceOf store.user, app.users.User

  # TODO: Other tests.
