import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';
import Songs from './songs.react';

export default class Index extends Component {

  static propTypes = {
    actions: React.PropTypes.object.isRequired,
    msg: React.PropTypes.object.isRequired,
    songs: React.PropTypes.object.isRequired
  }

  render() {
    const {actions, msg, songs} = this.props;

    return (
      <DocumentTitle title={msg.songs.index.title}>
        <Songs {...{actions, msg, songs}} />
      </DocumentTitle>
    );
  }

}
