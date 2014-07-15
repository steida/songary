###
  PATTERN(steida): There are various ways to prevent the compiler from
  renaming symbols: http://stackoverflow.com/questions/11681070/exposing-dynamically-created-functions-on-objects-with-closure-compiler
  Expose annotation seems to be ideal, but unfortunatelly their sucks:
  http://goo.gl/rOQP2c
  Quoted properties are brittle, people can forget.
  Externs ftw.
###
class appSongsStore
  appSongsStore::songs
  appSongsStore::newSong

# PATTERN(steida): For app.songs.Song create appSongsSong.
class appSongsSong
  appSongsSong::id
  appSongsSong::created
  appSongsSong::updated
  appSongsSong::name
  appSongsSong::urlName
  appSongsSong::artist
  appSongsSong::urlArtist
  appSongsSong::creator
  appSongsSong::lyrics