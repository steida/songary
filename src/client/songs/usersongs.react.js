// import './list.styl';
import Component from '../components/component.react';
import Loading from '../components/loading.react';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenFirebase from '../firebase/listenfirebase';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onSongsCreatedByUser,
  ref: firebase
    .child('songs')
    .orderByChild('createdBy')
    .equalTo(props.viewer.id)
}))
export default class UserSongs extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    userSongs: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  }

  render() {
    const {msg, userSongs, viewer} = this.props;
    const songs = userSongs.get(viewer.id);

    return (
      <div className="songs-usersongs">
        {songs
          ? <ol>
              {songs.map(song =>
                <li key={song.id}>
                  <SongLink song={song} />
                </li>
              )}
            </ol>
          : <Loading msg={msg} />
        }
      </div>
    );
  }

}
