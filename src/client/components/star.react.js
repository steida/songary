import './star.styl';
import Component from '../components/component.react';
import React from 'react';
import classnames from 'classnames';
import listenFirebase from '../firebase/listenfirebase';

@listenFirebase((props, firebase) => ({
  action: props.actions.songs.onSongStar,
  ref: firebase
    .child('songs-starred')
    .child(props.viewer.id)
    .child(props.song.id)
}))
export default class Star extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    checked: React.PropTypes.bool.isRequired,
    song: React.PropTypes.object.isRequired,
    viewer: React.PropTypes.object.isRequired
  }

  onStarClick() {
    const {actions, checked, song, viewer} = this.props;
    if (!viewer) return;
    actions.songs.star(viewer.id, song.id, !checked);
  }

  render() {
    const {checked} = this.props;
    const className = classnames('components-start', {checked});

    return (
      <span
        className={className}
        onClick={::this.onStarClick}
      />
    );
  }

}
