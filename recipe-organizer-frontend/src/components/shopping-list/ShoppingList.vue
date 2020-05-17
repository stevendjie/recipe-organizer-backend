<template>
  <div>
    <label>Shopping List Email:</label>
    <BFormInput class="mb-3" @input="updateShoppingListEmail" :value="shoppingListEmail"></BFormInput>
    <BButton variant="outline-dark" size="sm" @click="saveSettings">Save Setting</BButton>
    <div class="mt-5">
      <BButton block size="sm" class="mb-3" variant="outline-dark" @click="generateEmail">Generate Shopping List Template</BButton>
      <label class="text-center">E-mail content:</label>
      <textarea v-model="template">Generate E-mail Template</textarea>
      <BButton block variant="dark" class="mt-3">Send Email</BButton>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState, mapActions } from 'vuex'

export default {
  name: 'ShoppingList',
  data () {
    return {
      template: ''
    }
  },
  computed: {
    ...mapState(['shoppingListEmail']),
    ...mapGetters(['shoppingList', 'setup'])
  },
  created () {
    if (localStorage.signedIn && !this.setup) {
      this.$router.replace('/recipes')
    } else if (!localStorage.signedIn) {
      this.$router.replace('/')
    }
  },
  methods: {
    ...mapActions(['updateShoppingListEmail']),
    generateEmail () {
      let ingrStr = 'INGREDIENTS\n'
      let eqStr = 'EQUIPMENT\n'
      this.shoppingList.forEach((item) => {
        const { name } = item
        if (item.isIngredient) {
          ingrStr = `${ingrStr}${name}\n`
        } else {
          eqStr = `${eqStr}${name}\n`
        }
      })

      this.template = `${ingrStr}\n${eqStr}`
    },
    saveSettings () {
      this.$store.dispatch('saveSettings')
      .then(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Successfully saved settings!',
          type: 'success',
        })
      })
      .catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Successfully saved settings!',
          type: 'error',
        })
      })
    }
  }
}
</script>

<style scoped>
textarea {
  display: block;
  height: 500px;
  width: 100%;
}
</style>
