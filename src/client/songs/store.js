import Song from './song';
import {Map, Record, Seq} from 'immutable';
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
  return Seq(songs).reduce((state, json, id) => {
    return state.setIn(['map', id], json ? new Song(json) : null);
  }, state);
}

function setAll(state) {
  return state.set('all', toSortedSongsList(state.map.toJS()));
}

function setUserSongs(state, userId, songs) {
  return state.setIn(['userSongs', userId], toSortedSongsList(songs));
}

function revive(state = Map()) {
  const map = (state.get('map') || Map()).map(json => json && new Song(json));
  const all = toSortedSongsList(map.toJS());

  return new (Record({
    add: new Song,
    all: all,
    edited: Map(),
    map: map,
    starred: Map(),
    userSongs: Map()
  }));
}

export default function(state, action, payload) {
  if (!action) return revive(state);

  switch (action) {

  case actions.add:
    return state.set('add', new Song);

  case actions.cancelEdit:
    return state.removeIn(['edited', payload.id]);

  case actions.onSong: {
    const {id, value} = payload;
    return addToMap(state, {[id]: value});
  }

  case actions.onSongStar: {
    const {viewer, song, value} = payload;
    return value
      ? state.setIn(['starred', viewer.id, song.id], value)
      : state.removeIn(['starred', viewer.id, song.id]);
  }

  case actions.onSongs: {
    const songs = payload;
    // To ensure shown songs are removed.
    // TODO: Rethink. We should not reset map, but only update lists for
    // pagging etc., so app state can work as cache until we have a new data.
    state = state.set('map', Map());
    state = addToMap(state, songs);
    state = setAll(state);
    return state;
  }

  case actions.onUserSongs: {
    const {userId, songs} = payload;
    state = addToMap(state, songs);
    state = setUserSongs(state, userId, songs);
    return state;
  }

  case actions.save:
    return state.deleteIn(['edited', payload.id]);

  case actions.setSongField: {
    const {song, name, value} = payload;
    if (!song.id) return state.setIn(['add', name], value);
    return state.updateIn(['edited', song.id], (edited = song) =>
      edited.set(name, value));
  }

  }

  return state;
}
