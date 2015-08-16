import listenFirebase from '../firebase/listenfirebase';

export default function listenSong(BaseComponent) {
  return listenFirebase((props, firebase) => ({
    action: props.actions.songs.onSong,
    ref: firebase
      .child('songs')
      .child(props.params.id)
  }))(BaseComponent);
}
