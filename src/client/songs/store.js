import Song from './song';
import {Map, Record, Seq} from 'immutable';
import {actions} from './actions';

const mapToIds = songs => Seq(songs).map(s => s.id).toList();

// Map serves as cache and source of truth.
function addToMap(state, songs) {
  return Seq(songs).reduce((state, json, id) => {
    return json
      ? state.setIn(['map', id], new Song(json))
      : state.removeIn(['map', id]);
  }, state);
}

function addToLatest(state, latest) {
  const {map} = state;
  return Map(latest).reduce((s, songs, createdAt) => {
    const sorted = Seq(songs).sortBy(song => song.createdAt).reverse();
    const sortedIds = mapToIds(sorted);
    return s.setIn(['latest', createdAt], sortedIds);
  }, state);
}

function revive(state = Map()) {
  let initalState = new (Record({
    add: new Song,
    edited: Map(),
    latest: Map(),
    map: Map(),
    starred: Map(),
    user: Map()
  }));

  initalState = addToMap(initalState, state.get('map') || Map());
  initalState = addToLatest(initalState, state.get('latest') || Map());
  return initalState;
}

export default function songsStore(state, action, payload) {
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

  case actions.onLatest: {
    const {createdAt, songs} = payload;
    state = addToMap(state, songs);
    state = addToLatest(state, {[createdAt]: songs});
    return state;
  }

  case actions.onSongStar: {
    const {viewer, song, value} = payload;
    return value
      ? state.setIn(['starred', viewer.id, song.id], value)
      : state.removeIn(['starred', viewer.id, song.id]);
  }

  case actions.onUserSongs: {
    const {userId, songs} = payload;
    return addToMap(state, songs)
      .setIn(['user', userId], mapToIds(songs));
  }

  case actions.onUserStarredSongs: {
    const {songsIds, userId} = payload;
    return state.setIn(['starred', userId], Map(songsIds));
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
