<template>
  <div id="app">
    <Nav />
    <div class="container">
      <div class="col-md-12">
        <RouterView />
      </div>
    </div>
  </div>
</template>

<script>
import Nav from './components/nav/nav.vue'

export default {
  name: 'App',
  components: {
    Nav
  }
}
</script>
