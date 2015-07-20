import Component from '../components/component.react';
import DocumentTitle from 'react-document-title';
import React from 'react';

export default class Index extends Component {

  static propTypes = {
    msg: React.PropTypes.object.isRequired
  };

  render() {
    const {msg: {home: msg}} = this.props;

    return (
      <DocumentTitle title={msg.title}>
        <div className="home-page">
          <p>
            Your app here.
          </p>
        </div>
      </DocumentTitle>
    );
  }

}
