suite 'server.songs', ->

  songs = server.songs

  suite 'toPublishedJson', ->
    json = null
    setup ->
      json =
        "id": "s3if8iizlliq"
        "name": "Abdul Hasan"
        "artist": "Tři Sestry"
        "album": ""
        "lyrics": "{title: Abdul Hasan} [Emi]Léto je a [C]voní Rýnem Vl[G]ta[Emi]va"
        "urlName": "abdul-hasan"
        "urlArtist": "tri-sestry"
        "urlAlbum": ""
        "publisher": "facebook:10152605968388656"

    test 'should return published song', (done) ->
      promise = songs.toPublishedJson json, null, -> "2014-09-24T02:20:26.258Z"

      promise.then (publishedJson) ->
        assert.notEqual json, publishedJson
        assert.equal json.name, publishedJson.name
        # Should remove chords [] and control sequences {}.
        assert.equal publishedJson.lyricsForSearch, 'Léto je a voní Rýnem Vltava'
        assert.equal publishedJson.language, 'cs'
        assert.equal publishedJson.updatedAt, "2014-09-24T02:20:26.258Z"
        done()

    test 'should return published song with defined updatedAt', (done) ->
      promise = songs.toPublishedJson json, 'foo'
      promise.then (publishedJson) ->
        assert.equal publishedJson.updatedAt, 'foo'
        done()
