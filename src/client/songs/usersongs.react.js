import Component from '../components/component.react';
import Loading from '../components/loading.react';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenFirebase from '../firebase/listenfirebase';
import {lastUpdatedSorter} from './song.js';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onUserSongs,
  ref: firebase
    .child('songs')
    .orderByChild('createdBy')
    .equalTo(props.viewer.id)
}))
export default class UserSongs extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  }

  render() {
    const {msg, songs: {map, user}, viewer} = this.props;
    const viewerSongs = user.get(viewer.id);

    if (!viewerSongs) return <Loading msg={msg} />;

    // TODO: if !viewerSongs.size render some helper text.

    const songs = viewerSongs
      .map(id => map.get(id))
      .sortBy(lastUpdatedSorter)
      .reverse();

    return (
      <div className="songs-user">
        {songs.size > 0 &&
          <h2>{msg.songs.my.songsYouAdded}</h2>
        }
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
