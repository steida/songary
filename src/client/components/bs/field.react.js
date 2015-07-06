import Component from '../component.react';
import React from 'react';
import Textarea from 'react-textarea-autosize';
import classnames from 'classnames';
import {ValidationError} from '../../lib/validation';

class Field extends Component {

  static propTypes = {
    error: React.PropTypes.instanceOf(ValidationError),
    id: React.PropTypes.string,
    label: React.PropTypes.node,
    name: React.PropTypes.string,
    onKeyEnter: React.PropTypes.func,
    onKeyEscape: React.PropTypes.func,
    type: React.PropTypes.string,
    value: React.PropTypes.string
  };

  static focusToEnd(field) {
    field.focus();
    const length = field.value.length;
    field.selectionStart = length;
    field.selectionEnd = length;
  }

  constructor(props) {
    super(props);
    this.onKeyDown = this.onKeyDown.bind(this);
  }

  getField() {
    return React.findDOMNode(this.refs.field);
  }

  focus() {
    const field = this.getField();
    if (!field) return;
    field.focus();
  }

  select() {
    const field = this.getField();
    if (!field) return;
    field.select();
  }

  focusToEnd() {
    const field = this.getField();
    if (!field) return;
    Field.focusToEnd(field);
  }

  clear() {
    const field = this.getField();
    if (!field) return;
    field.value = '';
  }

  getValue() {
    const field = this.getField();
    return field ? field.value : '';
  }

  onKeyDown(e) {
    switch (e.key) {
      case 'Escape':
        if (this.props.onKeyEscape)
          this.props.onKeyEscape(e);
        break;
      case 'Enter':
        if (this.props.onKeyEnter)
          this.props.onKeyEnter(e);
        break;
    }
  }

  render() {
    const hasError =
      this.props.error &&
      this.props.error.prop === this.props.name;

    return (
      <div className={classnames('form-group', {'has-error': hasError})}>
        {this.props.label &&
          <label htmlFor={this.props.id}>{this.props.label}</label>}
        {this.props.type === 'textarea'
          ? <Textarea
              className="form-control"
              onKeyDown={this.onKeyDown}
              ref="field"
              {...this.props}
            />
          : <input
              className="form-control"
              onKeyDown={this.onKeyDown}
              ref="field"
              {...this.props}
            />
        }
      </div>
    );
  }

}

export default Field;
