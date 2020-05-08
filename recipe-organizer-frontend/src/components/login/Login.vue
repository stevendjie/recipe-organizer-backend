<template>
  <div>
    <label>Email</label>
    <BFormInput v-model="email" placeholder="Enter your email" class="mb-3" type="email" @keyup.enter="login"></BFormInput>
    <label>Password</label>
    <BFormInput v-model="password" placeholder="Enter your password" class="mb-3" type="password" @keyup.enter="login"></BFormInput>
    <div class="text-center">
      <BButton variant="outline-primary" class="mr-2" @click="login">Login</BButton>
      <RouterLink to="/signup">
        Sign Up
      </RouterLink>
    </div>
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
      const { email, password } = this
      this.$http.plain.post('/login', { email, password })
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
      window.location.reload()
    },
    loginFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || 'Login failed'
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
