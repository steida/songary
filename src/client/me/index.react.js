import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import ListSongs from '../songs/list.react';
import Logout from '../auth/logout.react';
import React from 'react';
import requireAuth from '../auth/requireauth.react';
import {Link} from 'react-router';
import {format} from '../intl/store';

@requireAuth
export default class Index extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    users: React.PropTypes.object.isRequired
  };

  render() {
    const {
      actions, msg,
      songs: {add, list},
      users: {viewer}
    } = this.props;

    return (
      <DocumentTitle title={msg.me.title}>
        <div className="me-page">
          <p>{format(msg.me.welcome, {email: viewer.email})}</p>
          <ListSongs {...{actions, list, viewer}} />
          <p>
            <Link to="songs-add">Add New Song</Link>
          </p>
          <Logout {...{actions, msg}} />
        </div>
      </DocumentTitle>
    );
  }

}