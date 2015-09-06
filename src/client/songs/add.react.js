import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import SongForm from './songform.react';
import requireAuth from '../auth/requireauth';

@requireAuth
export default class Add extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {
      actions: {songs: actions}, msg,
      songs: {add: song}
    } = this.props;

    return (
      <DocumentTitle title={msg.songs.add.title}>
        <div className="songs-add">
          <SongForm {...{actions, msg, song}} />
        </div>
      </DocumentTitle>
    );
  }

}
