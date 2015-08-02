import './add.styl';
import Component from '../components/component.react';
import React from 'react';
import requireAuth from '../auth/requireauth.react';

@requireAuth
export default class Add extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired,
    users: React.PropTypes.object.isRequired
  }

  onAddClick(e) {
    const el = React.findDOMNode(this.refs.lyrics);
    if (!el.value.trim()) return;
    const {actions, songs: {add: song}, users: {viewer}} = this.props;
    actions.songs.add(song, viewer);
  }

  render() {
    const {
      actions: {songs: actions},
      msg: {songs: {add: msg}},
      songs: {add: song}
    } = this.props;

    return (
      <div className="songs-add">
        <input
          autoFocus
          name="name"
          onChange={actions.setAddSongField}
          placeholder="song name"
          value={song.name}
        />
        <input
          name="artist"
          onChange={actions.setAddSongField}
          placeholder="artist"
          value={song.artist}
        />
        <textarea
          name="lyrics"
          onChange={actions.setAddSongField}
          placeholder={msg.placeholder}
          ref="lyrics"
          value={song.lyrics}
        />
        <div>
          <button onClick={() => this.onAddClick()}>add</button>
        </div>
      </div>
    );
  }

}
