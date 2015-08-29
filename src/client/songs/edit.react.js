import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import Loading from '../components/loading.react';
import React from 'react';
import SongForm from './songform.react';
import listenSong from './listensong';
import requireAuth from '../auth/requireauth.react';

@listenSong
@requireAuth
export default class Edit extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {
      actions: {songs: actions}, msg,
      params: {id},
      songs
    } = this.props;

    const song = songs.map.get(id);
    const editedSong = songs.edited.get(id);

    return (
      <DocumentTitle title={msg.songs.edit.title}>
        <div className="songs-edit">
          <h2>{msg.songs.edit.title}</h2>
          {song
            ? <SongForm {...{actions, msg, song, editedSong}} editMode />
            : <Loading msg={msg} />
          }
        </div>
      </DocumentTitle>
    );
  }

}
