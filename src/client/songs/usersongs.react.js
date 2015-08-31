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
    const ids = user.get(viewer.id);

    if (!ids) return <Loading msg={msg} />;

    // Songs are fetched as whole list, so we can expect map is fullfiled.
    const songs = ids
      .map(id => map.get(id))
      .filter(song => song) // But song can be deleted and not yet fb synced.
      .sortBy(lastUpdatedSorter)
      .reverse();

    // TODO: Render "you have not added song" call to action message for !size.

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
