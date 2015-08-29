// import './loading.styl';
import Component from '../components/component.react';
import React from 'react';

export default class Loading extends Component {

  static propTypes = {
    delay: React.PropTypes.number,
    msg: React.PropTypes.object.isRequired
  }

  // http://www.nngroup.com/articles/response-times-3-important-limits/
  static defaultProps = {
    delay: 3000
  }

  constructor(props) {
    super(props);
    this.state = {shown: false};
  }

  componentDidMount() {
    this.timer = setTimeout(() => {
      this.setState({shown: true});
    }, this.props.delay);
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  render() {
    const {msg: {components: msg}} = this.props;

    // TODO: Some animated progress, rule .1s 1s 10s.
    return (
      <div className="components-loading">
        <p>
          {this.state.shown && msg.loading}
        </p>
      </div>
    );
  }

}
