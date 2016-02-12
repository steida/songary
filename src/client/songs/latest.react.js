import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import Loading from '../components/loading.react';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenFirebase from '../firebase/listenfirebase';
import {Link} from 'react-router';

export const latestPageSize = 16;

@listenFirebase(props => ({
  action: props.actions.songs.onLatest,
  query: {
    child: 'songs',
    orderByChild: 'createdAt',
    [props.params.createdAt ? 'endAt' : '']: Number(props.params.createdAt),
    limitToLast: latestPageSize
  }
}))
export default class Latest extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {msg, params: {createdAt}, songs: {latest, map}} = this.props;
    const latestSongs = latest.get(createdAt);

    return (
      <DocumentTitle title={msg.songs.latest.title}>
        <div className="latest-page">
          {this.renderSongs(latestSongs, map, msg)}
        </div>
      </DocumentTitle>
    );
  }

  // TODO: Should be component at some point.
  renderSongs(latestSongs, map, msg) {
    if (!latestSongs)
      return <Loading msg={msg} />;

    const loadedSongs = latestSongs
      .map(id => map.get(id))
      .filter(song => song);

    if (!loadedSongs.size)
      return <p>{msg.songs.latest.noSongs}</p>

    // Because last song is link to older songs.
    const shownSongs = loadedSongs.slice(0, latestPageSize - 1);
    const showMoreButton = loadedSongs.size === latestPageSize;

    return (
      <div>
        <ol className="songs">{
          shownSongs.map(song =>
            <li key={song.id}>
              <SongLink song={song} />
            </li>
          )}
        </ol>
        {showMoreButton &&
          <Link
            params={{createdAt: loadedSongs.last().createdAt}}
            to="latest"
          >{msg.songs.latest.more}</Link>
        }
      </div>
    );
  }

}
