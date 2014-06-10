suite 'app.songs.Song', ->

  Song = app.songs.Song
  song = null

  suite 'constructor', ->
    test 'should set name and chordpro', ->
      song = new Song 'Name', 'Chordpro'
      assert.equal song.name, 'Name'
      assert.equal song.chordpro, 'Chordpro'

  suite 'validate', ->
    test 'should return empty array for valid song', ->
      song = new Song 'Name', 'Bla [Ami]'
      assert.deepEqual song.validate(), []

    test 'should validate invalid name', ->
      song = new Song '', 'Bla [Ami]'
      assert.deepEqual song.validate(), [
        prop: 'name'
        message: 'Please fill out name.'
      ]

    test 'should validate invalid chordpro', ->
      song = new Song 'Hey Jude', ''
      assert.deepEqual song.validate(), [
        prop: 'chordpro'
        message: 'Please fill out chordpro.'
      ]