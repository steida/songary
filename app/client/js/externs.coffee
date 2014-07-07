###
  PATTERN(steida): There are various ways to prevent the compiler from
  renaming symbols: http://stackoverflow.com/questions/11681070/exposing-dynamically-created-functions-on-objects-with-closure-compiler
  Expose annotation seems to be ideal, but unfortunatelly it's not reliable:
  http://goo.gl/rOQP2c Quoted properties are brittle, people can forget.
  Externs interfaces ftw.
###

class SongsStoreProps
  ###* @interface ###
  constructor: ->

SongsStoreProps::songs
SongsStoreProps::newSong

class SongProps
  ###* @interface ###
  constructor: ->

SongProps::id
SongProps::created
SongProps::updated
SongProps::name
SongProps::urlName
SongProps::artist
SongProps::urlArtist
SongProps::creator
SongProps::lyrics