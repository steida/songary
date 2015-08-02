import {Record} from 'immutable';

const SongRecord = Record({
  album: '',
  artist: '',
  createdAt: null,
  createdBy: null,
  id: '',
  lyrics: '',
  name: '',
  updatedAt: null
});

export default class Song extends SongRecord {}
