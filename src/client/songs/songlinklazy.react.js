import Component from '../components/component.react';
import React from 'react';
import SongLink from '../songs/songlink.react';
import listenSong from './listensong';

@listenSong
export default class SongLinkLazy extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    params: React.PropTypes.object.isRequired,
    song: React.PropTypes.object
  }

  render() {
    const {song} = this.props;
    if (!song) return null;

    return (
      <SongLink song={song} />
    );
  }

}
