import Song from './song';
import {List, Map, Record, Seq} from 'immutable';
import {actions} from './actions';

const lastUpdatedSorter = song => song.updatedAt || song.createdAt;

function toSortedSongsList(iterable) {
  return Seq(iterable)
    .filter(song => song)
    .map(song => new Song(song))
    .sortBy(lastUpdatedSorter)
    .reverse()
    .toList();
}

function addToMap(state, songs) {
  Seq(songs).forEach(json => {
    if (!json) return;
    const song = new Song(json);
    state = state.setIn(['map', song.id], song);
  });
  return state;
}

function setLastAdded(state) {
  return state.set('lastAdded', toSortedSongsList(state.map));
}

function setUserSongs(state, userId, songs) {
  return state.setIn(['userSongs', userId], toSortedSongsList(songs));
}

function revive(state = Map()) {
  return new (Record({
    add: new Song,
    lastAdded: List(),
    map: (state.get('map') || Map()).map(json => json && new Song(json)),
    userSongs: Map()
  }));
}

export default function(state, action, payload) {
  if (!action) return revive(state);

  switch (action) {

  case actions.add:
    return state.set('add', new Song);

  case actions.onSong: {
    const {id, value} = payload;
    return state.setIn(['map', id], value ? new Song(value) : null);
  }

  case actions.onSongsCreatedByUser: {
    const {userId, songs} = payload;
    state = addToMap(state, songs);
    state = setLastAdded(state);
    state = setUserSongs(state, userId, songs);
    return state;
  }

  case actions.setAddSongField: {
    const {name, value} = payload;
    return state.setIn(['add', name], value);
  }

  }

  return state;
}
