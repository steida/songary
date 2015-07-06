import Component from '../component.react';
import React from 'react';
import classnames from 'classnames';

class Alert extends Component {

  static propTypes = {
    children: React.PropTypes.node,
    type: React.PropTypes.oneOf(['success', 'info', 'warning', 'danger'])
  };

  render() {
    const type = this.props.type || 'success';
    const className = classnames('alert', 'alert-' + type);
    return (
      <div className={className} role="alert" {...this.props}>
        {this.props.children}
      </div>
    );
  }

}

export default Alert;
