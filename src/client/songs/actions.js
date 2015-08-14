import Song from './song';

export const actions = create();
export const feature = 'songs';

export function create(dispatch, validate, firebase, router) {

  return {

    add(song, viewer) {
      return validate(song)
        .prop('name').required()
        .prop('artist').required()
        .prop('lyrics').required()
        .promise
        .then(() => {
          const newSong = Song.createNew(song, viewer, firebase.TIMESTAMP);
          // Optimistic add for now. TODO: Catch errors.
          firebase.set(['songs', newSong.id], newSong.toJS());
          dispatch(actions.add);
          router.transitionTo('me');
        });
    },

    addFromJson(songs, viewer) {
      // songs.forEach(song => {
      //   song = new Song(song).merge({
      //     createdAt: firebase.TIMESTAMP,
      //     updatedAt: firebase.TIMESTAMP,
      //     createdBy: viewer.id
      //   }).toJS();
      //   firebase.set(['songs', viewer.id, song.id], song);
      // });
    },

    delete(song, viewer) {
      firebase.remove(['songs', viewer.id, song.id]);
    },

    onSong(snapshot, {params: {id}}) {
      dispatch(actions.onSong, {id, value: snapshot.val()});
    },

    onSongsCreatedByUser(snapshot, {viewer: {id}}) {
      dispatch(actions.onSongsCreatedByUser, {
        songs: snapshot.val(),
        userId: id
      });
    },

    setAddSongField({target: {name, value}}) {
      value = value.slice(0, Song.maxLength[name]);
      dispatch(actions.setAddSongField, {name, value});
    }

  };

}
