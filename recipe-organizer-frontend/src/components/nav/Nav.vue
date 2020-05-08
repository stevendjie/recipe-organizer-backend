<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4">
    <RouterLink to="/" class="navbar-brand">&copy; S.D.</RouterLink>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav">
        <li class="nav-item" :class="{ 'active': currentPath === '/' }" v-if="!loggedIn">
          <RouterLink to="/" class="nav-link">Login</RouterLink>
        </li>
        <li class="nav-item" :class="{ 'active': currentPath === '/signup' }" v-if="!loggedIn">
          <RouterLink to="/signup" class="nav-link">Sign Up</RouterLink>
        </li>
        <li class="nav-item" :class="{ 'active': currentPath === '/recipes' }" v-if="loggedIn">
          <RouterLink to="/recipes" class="nav-link">Dashboard</RouterLink>
        </li>
        <li class="nav-item" :class="{ 'active': currentPath === '/shopping-list' }" v-if="loggedIn">
          <RouterLink to="/shopping-list" class="nav-link">Shopping List</RouterLink>
        </li>
        <li class="nav-item logout" v-if="loggedIn">
          <a class="nav-link" @click="logout">Logout</a>
        </li>
      </ul>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Nav',
  data () {
    return {
      currentPath: ''
    }
  },
  computed: {
    loggedIn () {
      return localStorage.signedIn
    }
  },
  methods: {
    logout () {
      this.$http.secured.delete('/login')
        .then(response => {
          delete localStorage.csrf
          delete localStorage.signedIn
          this.$router.replace('/')
          window.location.reload()
        })
    }
  },
  watch: {
    $route: {
      immediate: true,
      handler (to) {
        this.currentPath = to.path
      }
    }
  }
}

</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Pacifico&display=swap');

.navbar-nav {
  flex-basis: 100%;
}

.navbar-brand {
  font-family: 'Pacifico', cursive;
  font-size: 1.5rem;
}

.logout {
  margin-left: auto;
  cursor: pointer;
}
</style>
