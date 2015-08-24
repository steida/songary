import './index.styl';
import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import Loading from '../components/loading.react';
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
    const {msg, songs: {all}} = this.props;

    // Because all is never undefined, and zero means loading.
    if (!all.size) return <Loading msg={msg} />;

    return (
      <DocumentTitle title={msg.songs.index.title}>
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
