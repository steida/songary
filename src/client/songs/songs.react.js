import Component from '../components/component.react';
import Loading from '../components/loading.react';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenFirebase from '../firebase/listenfirebase';
import {lastUpdatedSorter} from './song.js';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onSongs,
  ref: firebase.child('songs')
}))
export default class Index extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {msg, songs: {all, map}} = this.props;

    const songs = all
      .map(id => map.get(id))
      .sortBy(lastUpdatedSorter)
      .reverse();

    // Because all is never undefined nor empty, zero means loading.
    if (!songs.size) return <Loading msg={msg} />;

    return (
      <div className="songs">
        <ol>
          {songs.map(song =>
            <li key={song.id}>
              <SongLink song={song} />
            </li>
          )}
        </ol>
      </div>
    );
  }

}
