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

}
