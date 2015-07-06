import {Record} from 'immutable';

const FormRecord = Record({
  fields: new (Record({
    email: '',
    password: ''
  })),
  error: null
});

export default class Form extends FormRecord {
  // We can add getters here. For example:
  // get emailIsTheSameAsPassword() {
  //   return this.email === this.password;
  // }
}
