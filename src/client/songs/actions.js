import Song from './song';

// import Fixtures from '../../../firebase/export';
// import {Seq} from 'immutable';

export const actions = create();
export const feature = 'songs';

export function create(dispatch, validate, firebase, router, state) {

  const validateSong = (song) => validate(song)
    .prop('name').required()
    .prop('artist').required()
    .prop('lyrics').required()
    .promise;

  return {

    add(song) {
      const {users: {viewer}} = state();
      return validateSong(song)
        .then(() => {
          song = Song.createNew(song, viewer, firebase.TIMESTAMP);
          dispatch(actions.add);
          // TODO: Catch and handle errors. Consider pending action.
          firebase.set(['songs', song.id], song.toSave());
          router.transitionTo('song', {id: song.id});
        });
    },

    // addFixtures() {
    //   const {users: {viewer}} = state();
    //   const songs = Seq(Fixtures.songs).map(json => {
    //     const song = new Song(json);
    //     return Song.createNew(song, viewer, firebase.TIMESTAMP)
    //       .set('id', json.id)
    //       .toSave();
    //   }).toJS();
    //   firebase.update(['songs'], songs);
    // },

    cancelEdit(id) {
      dispatch(actions.cancelEdit, {id});
      router.transitionTo('song', {id});
    },

    delete(id) {
      dispatch(actions.delete, {id});
      // Remove deletes song from app state via onSong returning id and
      // value === null.
      firebase.remove(['songs', id]);
      router.transitionTo('my-songs');
    },

    save(song) {
      const {id} = song;
      return validateSong(song)
        .then(() => {
          song = song.set('updatedAt', firebase.TIMESTAMP);
          firebase.set(['songs', id], song.toSave());
          dispatch(actions.save, {id});
          router.transitionTo('song', {id});
        });
        // TODO: Catch and handle errors. Add pending action.
    },

    star(userId, songId, enabled) {
      dispatch(actions.star, {userId, songId, enabled});
      const value = enabled
        ? {createdAt: firebase.TIMESTAMP}
        : null;
      firebase.set(['songs-starred', userId, songId], value);
    },

    onSong(snapshot, {params: {id}}) {
      dispatch(actions.onSong, {id, value: snapshot.val()});
    },

    onSongStar(snapshot, {viewer, song}) {
      dispatch(actions.onSongStar, {viewer, song, value: snapshot.val()});
    },

    onSongs(snapshot) {
      dispatch(actions.onSongs, snapshot.val());
    },

    onSongsCreatedByUser(snapshot, {viewer: {id}}) {
      dispatch(actions.onSongsCreatedByUser, {
        songs: snapshot.val(),
        userId: id
      });
    },

    setSongField(song, {name, value}) {
      value = value.slice(0, Song.maxLength[name]);
      dispatch(actions.setSongField, {song, name, value});
    }

  };

}
