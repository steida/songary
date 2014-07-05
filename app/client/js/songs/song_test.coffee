suite 'app.songs.Song', ->

  Song = app.songs.Song
  song = null

  suite 'constructor', ->
    test 'should set name and lyrics', ->
      song = new Song
      assert.equal song.name, ''
      assert.equal song.artist, ''
      assert.equal song.lyrics, ''
      song = new Song 'Name', 'Artist', 'Lyrics'
      assert.equal song.name, 'Name'
      assert.equal song.artist, 'Artist'
      assert.equal song.lyrics, 'Lyrics'

  suite 'validate', ->
    test 'should return empty array for valid song', ->
      song = new Song 'Name', 'Artist', 'Bla [Ami]'
      assert.deepEqual song.validate(), []

    test 'should validate invalid name', ->
      song = new Song ' ', 'Artist', 'Bla [Ami]'
      assert.deepEqual song.validate(), [
        prop: 'name'
        message: 'Please fill out name.'
      ]

    test 'should validate invalid artist', ->
      song = new Song 'Hey Jude', ' ', '..'
      assert.deepEqual song.validate(), [
        prop: 'artist'
        message: 'Please fill out artist.'
      ]

    test 'should validate invalid lyrics', ->
      song = new Song 'Hey Jude', 'Beatles', ''
      assert.deepEqual song.validate(), [
        prop: 'lyrics'
        message: 'Please fill out lyrics.'
      ]

  suite 'updateUrlNames', ->
    test 'should update urlName and urlArtist', ->
      song = new Song 'Hey Jude', 'Beatles', ''
      song.updateUrlNames()
      assert.equal song.urlName, 'hey-jude'
      assert.equal song.urlArtist, 'beatles'