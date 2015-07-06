export default {
  en: {
    auth: {
      title: 'Login / Sign Up',
      legend: 'Login / Sign Up',
      emailForm: {
        legend: 'Email',
        placeholder: {
          email: 'your@email.com',
          password: 'password'
        },
        button: {
          login: 'Login',
          signUp: 'Sign Up',
          forgotPassword: 'Forgot your password?',
          resetPassword: 'Reset password'
        },
        resetPassword: `We'll send you an email with instructions on how to reset it.`,
        emailSent: 'Email has been sent.'
      }
    },
    buttons: {
      cancel: 'Cancel',
      edit: 'Edit',
      logout: 'Logout',
      save: 'Save'
    },
    confirmations: {
      cancelEdit: `You have unsaved changes. Are you sure you want to cancel them?`
    },
    home: {
      title: 'Songary'
    },
    me: {
      title: 'Me',
      welcome: `Hi {email}.`
    },
    notFound: {
      continueMessage: 'Continue here please.',
      header: 'This page isn\'t available',
      message: 'The link may be broken, or the page may have been removed.',
      title: 'Page Not Found'
    },
    validation: {
      email: `Email address is not valid.`,
      password: `Password must contain at least {minLength} characters.`,
      required: `Please fill out {prop, select,
        email {email}
        password {password}
        other {'{prop}'}
      }.`
    }
  }
};
