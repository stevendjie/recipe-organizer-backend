<template>
  <div>
    <label>Email</label>
    <BFormInput v-model="email" placeholder="Enter your email" class="mb-3" type="email"></BFormInput>
    <label>Password</label>
    <BFormInput v-model="password" placeholder="Enter your password" class="mb-3" type="password"></BFormInput>
    <label>Confirm Password</label>
    <BFormInput v-model="passwordConfirmation" placeholder="Re-enter your password" class="mb-3" type="password"></BFormInput>
    <div class="text-center">
      <BButton variant="outline-primary" class="mr-2" @click="signup">Sign Up</BButton>
      <RouterLink to="/">
        Login
      </RouterLink>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Signup',
  data () {
    return {
      email: '',
      password: '',
      passwordConfirmation: ''
    }
  },
  created () {
    this.checkLogggedIn()
  },
  updated () {
    this.checkLogggedIn()
  },
  methods: {
    signup () {
      const { email, password, passwordConfirmation } = this
      this.$http.plain.post('/signup', { email, password, password_confirmation: passwordConfirmation })
        .then(response => this.loginSuccessful(response))
        .catch(error => this.loginFailed(error))
    },
    loginSuccessful (response) {
      if (!response.data.csrf) {
        this.loginFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/recipes')
    },
    loginFailed (error) {
      const text = (error.response && error.response.data && error.response.data.error) || ''
      this.$notify({
        group: 'app-notifications',
        title: 'Failed to create a new account.',
        type: 'error',
        text 
      });
      delete localStorage.csrf
      delete localStorage.signedIn
    },
    checkLogggedIn () {
      if (localStorage.signedIn) {
        this.$router.replace('/recipes')
      }
    }
  }
}

</script>
