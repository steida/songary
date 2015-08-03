import getRandomString from '../lib/getrandomstring';
import {Record} from 'immutable';

const SongRecord = Record({
  artist: '',
  createdAt: null,
  createdBy: null,
  id: '',
  lyrics: '',
  name: '',
  updatedAt: null
});

export default class Song extends SongRecord {

  static maxLength = {
    artist: 100,
    lyrics: 10000,
    name: 100
  }

  static createNew(song, viewer, TIMESTAMP) {
    return song.merge({
      createdAt: TIMESTAMP,
      createdBy: viewer.id,
      id: getRandomString(),
      updatedAt: TIMESTAMP
    });
  }

}
