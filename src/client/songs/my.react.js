import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import UserSongs from '../songs/usersongs.react';
import requireAuth from '../auth/requireauth.react';

@requireAuth
export default class My extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    users: React.PropTypes.object.isRequired
  }

  render() {
    const {actions, msg, songs: {userSongs}, users: {viewer}} = this.props;

    return (
      <DocumentTitle title={msg.songs.my.title}>
        <div className="me-page">
          {userSongs.size > 0 &&
            <h2>{msg.songs.my.songsYouAdded}</h2>
          }
          <UserSongs {...{actions, msg, viewer, userSongs}} />
          {false &&
            <h2>{msg.songs.my.songsYouStarred}</h2>
          }
        </div>
      </DocumentTitle>
    );
  }

}
