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
  Seq(songs).forEach(json => {
    const song = json && new Song(json);
    state = state.setIn(['map', song.id], song);
  });
  return state;
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
    // TODO: Use add to map imho as well.
    return state.setIn(['map', id], value ? new Song(value) : null);
  }

  case actions.onSongs: {
    const songs = payload;
    state = addToMap(state, songs);
    state = setAll(state);
    return state;
  }

  case actions.onSongsCreatedByUser: {
    const {userId, songs} = payload;
    state = addToMap(state, songs);
    state = setAll(state);
    state = setUserSongs(state, userId, songs);
    return state;
  }

  case actions.save:
    return state.deleteIn(['edited', payload.id]);

  case actions.setAddSongField: {
    const {name, value} = payload;
    return state.setIn(['add', name], value);
  }

  case actions.setSongField: {
    const {song, name, value} = payload;
    if (!song.id) return state.setIn(['add', name], value);

    return state.updateIn(['edited', song.id], (edited = song) =>
      edited.set(name, value));
  }

  }

  return state;
}
