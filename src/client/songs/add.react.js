import './add.styl';
import Component from '../components/component.react';
import React from 'react';

export default class Add extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    song: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  };

  onInputKeyDown(e) {
    if (e.key !== 'Enter') return;
    if (!e.target.value.trim()) return;
    const {actions, song, viewer} = this.props;
    actions.songs.add(song, viewer);
  }

  render() {
    const {
      actions: {songs: actions},
      msg: {songs: {add: msg}},
      song
    } = this.props;

    return (
      <div className="songs-add">
        <input
          autoFocus
          name="text"
          onChange={actions.setAddField}
          onKeyDown={::this.onInputKeyDown}
          placeholder={msg.placeholder}
          value={song.text}
        />
      </div>
    );
  }

}
