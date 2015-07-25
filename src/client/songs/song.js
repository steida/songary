import {Record} from 'immutable';

const SongRecord = Record({
  createdAt: null,
  id: '',
  text: ''
});

export default class Song extends SongRecord {}
