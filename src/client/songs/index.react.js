import './index.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenFirebase from '../firebase/listenfirebase';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onSongs,
  ref: firebase.child('songs')
}))
export default class Index extends Component {

  static propTypes = {
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {msg: {songs: {index: msg}}, songs: {all}} = this.props;

    return (
      <DocumentTitle title={msg.title}>
        <div className="songs-list">
          <ol>
            {all.map(song =>
              <li key={song.id}>
                <SongLink song={song} />
              </li>
            )}
          </ol>
        </div>
      </DocumentTitle>
    );
  }

}
