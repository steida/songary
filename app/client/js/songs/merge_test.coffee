suite 'app.songs.merge', ->

  merge = app.songs.merge

  suite 'lyrics', ->
    test 'should merge ...', ->
      # oldVersion = 'And Hamlet: Lala la la'
      # newVersion = 'lala la la ou jee'
      # assert.equal merge.lyrics(oldVersion, newVersion), 'fok'
