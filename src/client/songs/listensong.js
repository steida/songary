import listenFirebase from '../firebase/listenfirebase';

export default function listenSong(BaseComponent) {
  return listenFirebase(props => ({
    action: props.actions.songs.onSong,
    query: {
      child: `songs/${props.params.id}`
    }
  }))(BaseComponent);
}
