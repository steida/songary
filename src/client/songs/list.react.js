import './list.styl';
import Component from '../components/component.react';
import React from 'react';
import listenFirebase from '../firebase/listenfirebase';
import {Link} from 'react-router';

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
    // TODO: Localize.
    if (!confirm('Are you sure?'))
      return;
    const {actions, viewer} = this.props;
    actions.songs.delete(song, viewer);
  }

  onLoadFromJsonClick() {
    const {actions, viewer} = this.props;
    const jsonString = prompt('Please enter JSON string.');
    const songs = JSON.parse(jsonString);
    actions.songs.addFromJson(songs, viewer);
  }

  render() {
    const {list} = this.props;

    return (
      <div className="songs-list">
        <ul>
          {list.map(song =>
            <li key={song.id}>
              <Link params={{id: song.id}} to="song">
                {song.name} / {song.artist}{' '}
              </Link>
              <button onClick={() => this.delete(song)}>x</button>
            </li>
          )}
        </ul>
        <p>
          {/* TODO: Move. */}
          <button onClick={::this.onLoadFromJsonClick}>Add from JSON</button>
        </p>
      </div>
    );
  }

}
