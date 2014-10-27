suite 'app.songs.Song', ->

  Song = app.songs.Song
  song = null

  createSong = (name, artist, album, lyrics) ->
    new Song
      name: name
      artist: artist
      album: album
      lyrics: lyrics

  suite 'validate', ->
    test 'should return resolved promise for valid model', (done) ->
      song = createSong 'Name', 'Artist', 'Album', 'Lyrics'
      song.validate().then -> done()

    test 'should return rejected promise for invalid model with errors', (done) ->
      # Album is optional.
      song = createSong '..', ' ', '', ' '
      song.validate().thenCatch (reason) ->
        assert.deepEqual reason.errors, [
          msg: 'Please fill out name.'
          props: ['name']
        ,
          msg: 'Please fill out artist.'
          props: ['artist']
        ,
          msg: 'Please fill out lyrics.'
          props: ['lyrics']
        ]
        done()

  suite 'computeProps', ->
    test 'should compute model properties', ->
      song = new Song
      song.name = new Array(101).join 'a'
      song.artist = new Array(101).join 'a'
      song.album = new Array(101).join 'a'
      song.lyrics = new Array(32001).join 'a'
      song.computeProps()
      assert.equal song.urlName.length, 100
      assert.equal song.urlArtist.length, 100
      assert.equal song.urlAlbum.length, 100
      assert.equal song.lyrics.length, 32000
