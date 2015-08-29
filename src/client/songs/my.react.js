import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import UserSongs from '../songs/usersongs.react';
import UserStarredSongs from '../songs/userstarredsongs.react';
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
    const {actions, msg, songs, users: {viewer}} = this.props;

    // TODO: Show both lists once they are both loaded. Use one loading?
    // Rethink. Use probably some toggle in songs store.

    return (
      <DocumentTitle title={msg.songs.my.title}>
        <div className="me-page">
          <UserStarredSongs {...{actions, msg, viewer, songs}} />
          <UserSongs {...{actions, msg, viewer, songs}} />
        </div>
      </DocumentTitle>
    );
  }

}
