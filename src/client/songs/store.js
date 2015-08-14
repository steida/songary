import Song from './song';
import {List, Map, Record, Seq} from 'immutable';
import {actions} from './actions';

function revive(state) {
  return new (Record({
    add: new Song,
    lastAdded: List(),
    map: Map(),
    userSongs: Map()
  }));
}

const lastUpdatedSorter = song => song.updatedAt || song.createdAt;

function addToMap(state, songs) {
  Seq(songs).forEach(json => {
    const song = new Song(json);
    state = state.setIn(['map', song.id], song);
  });
  return state;
}

function setLastAdded(state) {
  const lastAdded = state.map
    .toList()
    .sortBy(lastUpdatedSorter)
    .reverse();
  return state.set('lastAdded', lastAdded);
}

function setUserSongs(state, userId, songs) {
  const userSongs = state.map
    .toList()
    .sortBy(lastUpdatedSorter)
    .reverse();
  return state.setIn(['userSongs', userId], userSongs);
}

export default function(state, action, payload) {
  if (!action) return revive(state);

  switch (action) {

  case actions.add:
    return state.set('add', new Song);

  case actions.onSong:
    return addToMap(state, {[payload.id]: payload});

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
