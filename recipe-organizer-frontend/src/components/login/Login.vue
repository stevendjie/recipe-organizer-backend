<template>
  <div>
    <div v-if="error">
      {{ error }}
    </div>
    <p>Email Address</p>
    <input type="email" v-model="email" />
    <p>Password</p>
    <input type="password" v-model="password" />
    <button @click="login">
      Login
    </button>
    <RouterLink to="/signup">
      Sign Up
    </RouterLink>
  </div>
</template>

<script>
export default {
  name: 'Login',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkLogggedIn()
  },
  updated () {
    this.checkLogggedIn()
  },
  methods: {
    login () {
      this.$http.plain.post('/login', { email: this.email, password: this.password })
        .then(response => this.loginSuccessful(response))
        .catch(error => this.loginFailed(error))
    },
    loginSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      localStorage.signedIn = true
      this.error = ''
      this.$router.replace('/recipes')
    },
    loginFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
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
