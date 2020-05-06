<template>
  <div>
    <div v-if="error">
      {{ error }}
    </div>
    <p>Email Address</p>
    <input type="email" v-model="email" />
    <p>Password</p>
    <input type="password" v-model="password" />
    <p>Confirm Password</p>
    <input type="password" v-model="passwordConfirmation" />
    <button @click="signup">
      Signup
    </button>
    <RouterLink to="/login">
      Login
    </RouterLink>
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

<style scoped>

</style>
