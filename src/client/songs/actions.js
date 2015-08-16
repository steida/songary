import Song from './song';

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
          firebase.set(['songs', song.id], song.toSave());
          dispatch(actions.add);
          router.transitionTo('me');
        });
        // TODO: Catch and handle errors. Add pending action.
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

    // delete(song, viewer) {
    //   firebase.remove(['songs', viewer.id, song.id]);
    // },

    onSong(snapshot, {params: {id}}) {
      dispatch(actions.onSong, {id, value: snapshot.val()});
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

// addFromJson(songs, viewer) {
//     // songs.forEach(song => {
//     //   song = new Song(song).merge({
//     //     createdAt: firebase.TIMESTAMP,
//     //     updatedAt: firebase.TIMESTAMP,
//     //     createdBy: viewer.id
//     //   }).toJS();
//     //   firebase.set(['songs', viewer.id, song.id], song);
//     // });
//   }
