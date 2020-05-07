<template>
  <div>
    <BFormInput v-model="email" placeholder="Enter your email" class="mb-3" type="email"></BFormInput>
    <BFormInput v-model="password" placeholder="Enter your password" class="mb-3" type="password"></BFormInput>
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
      passwordConfirmation: '',
      error: ''
    }
  },
  created() {
    this.checkLogggedIn();
  },
  updated() {
    this.checkLogggedIn();
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
      this.error = (error.response && error.response.data && error.response.data.error) || 'Signup failed'
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
