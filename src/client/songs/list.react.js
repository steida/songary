import './list.styl';
import Component from '../components/component.react';
import React from 'react';
import listenFirebase from '../firebase/listenfirebase';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onFirebaseSongs,
  ref: firebase
    .child('songs')
    .child(props.viewer.id)
}))
export default class List extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    list: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  };

  delete(song) {
    const {actions, viewer} = this.props;
    actions.songs.delete(song, viewer);
  }

  render() {
    const {list} = this.props;

    return (
      <div className="songs-list">
        <ul>
          {list.map(song =>
            <li key={song.id}>
              {song.text}{' '}
              <button onClick={() => this.delete(song)}>x</button>
            </li>
          )}
        </ul>
      </div>
    );
  }

}
