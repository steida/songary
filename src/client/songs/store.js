import Song from './song';
import {Map, Record, Seq} from 'immutable';
import {actions} from './actions';

function addToMap(state, songs) {
  return Seq(songs).reduce((state, json, id) => {
    return json
      ? state.setIn(['map', id], new Song(json))
      : state.removeIn(['map', id]);
  }, state);
}

const mapToIds = songs => Seq(songs).map(s => s.id).toList();

function revive(state = Map()) {
  const map = (state.get('map') || Map()).map(json => new Song(json));

  return new (Record({
    add: new Song,
    all: mapToIds(map),
    edited: Map(),
    map: map,
    starred: Map(),
    user: Map()
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
    // Map serves as cache and source of truth.
    return addToMap(state, songs)
      .set('all', mapToIds(songs));
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
