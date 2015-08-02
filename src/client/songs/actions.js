import Song from './song';
import getRandomString from '../lib/getrandomstring';

export const actions = create();
export const feature = 'songs';

export function create(dispatch, validate, msg, firebase, router) {

  return {

    add(song, viewer) {
      const json = song.merge({
        createdAt: firebase.TIMESTAMP,
        id: getRandomString()
      }).toJS();
      firebase.set(['songs', viewer.id, json.id], json);
      // Optimistic add, Firebase always dispatches local changes anyway.
      dispatch(actions.add);
      router.transitionTo('me');
    },

    addFromJson(songs, viewer) {
      songs.forEach(song => {
        song = new Song(song).merge({
          createdAt: firebase.TIMESTAMP,
          updatedAt: null
        }).toJS();
        firebase.set(['songs', viewer.id, song.id], song);
      });
    },

    delete(song, viewer) {
      firebase.remove(['songs', viewer.id, song.id]);
    },

    onFirebaseSongs(eventType, snapshot, props) {
      dispatch(actions.onFirebaseSongs, snapshot.val());
    },

    setAddSongField({target: {name, value}}) {
      value = value.slice(0, Song.maxLength[name]);
      dispatch(actions.setAddSongField, {name, value});
    }

  };

}
