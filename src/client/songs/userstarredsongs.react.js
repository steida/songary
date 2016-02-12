import Component from '../components/component.react';
import Loading from '../components/loading.react';
import React from 'react';
import SongLinkLazy from '../songs/songlinklazy.react';
import listenFirebase from '../firebase/listenfirebase';
import {Seq} from 'immutable';

@listenFirebase(props => ({
  action: props.actions.songs.onUserStarredSongs,
  query: {
    child: `songs-starred/${props.viewer.id}`
  }
}))
export default class UserStarredSongs extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  }

  render() {
    const {actions, msg, songs: {map, starred}, viewer} = this.props;
    const userStarred = starred.get(viewer.id);

    if (!userStarred) return <Loading msg={msg} />;

    let ids = Seq(userStarred).keySeq().toList();
    const allLoaded = ids.every(id => map.has(id));
    if (allLoaded)
      ids = ids.sortBy(id => map.get(id).createdAt);
    const isEmpty = !ids.size;

    return (
      <div className="songs-userstarred">
        {allLoaded &&
          <h2>{msg.songs.my.songsYouStarred}</h2>
        }
        {allLoaded && isEmpty &&
          <p>{msg.songs.my.youHaveNoStarredSong}</p>
        }
        <ol className="songs" style={{display: allLoaded ? '' : 'none'}}>
          {ids.map(id =>
            <li key={id}>
              <SongLinkLazy
                actions={actions}
                key={id}
                params={{id}}
                song={map.get(id)}
              />
            </li>
          )}
        </ol>
      </div>
    );

  }

}
