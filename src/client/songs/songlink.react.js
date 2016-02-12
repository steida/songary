import Component from '../components/component.react';
import React from 'react';
import {Link} from 'react-router';

export default class SongLink extends Component {

  static propTypes = {
    song: React.PropTypes.object.isRequired
  }

  render() {
    const {song: {artist, id, name}} = this.props;

    return (
      <Link params={{id}} to="song">{name} - {artist}</Link>
    );
  }

}
