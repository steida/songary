// import './loading.styl';
import Component from '../components/component.react';
import React from 'react';

export default class Loading extends Component {

  static propTypes = {
    msg: React.PropTypes.object.isRequired
  }

  render() {
    const {msg: {components: msg}} = this.props;

    // TODO: Some animated progress, rule .1s 1s 10s.
    return (
      <div className="components-loading">
        <p>{msg.loading}</p>
      </div>
    );
  }

}
