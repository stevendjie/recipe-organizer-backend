<template>
  <div>
    <label>Send to:</label>
    <BFormInput class="mb-3" @input="updateShoppingListEmail" :value="shoppingListEmail"></BFormInput>
    <BButton variant="outline-dark" size="sm" @click="saveSettings">Save Setting</BButton>
    <div class="mt-5">
      <BButton block size="sm" class="mb-3" variant="outline-dark" @click="generateEmail">Generate Shopping List Template</BButton>
      <label class="text-center">E-mail content:</label>
      <textarea v-model="template"></textarea>
      <BButton size="sm" block variant="dark" class="mt-3" @click="sendShoppingList" :disabled="disableSendEmail">Send Email</BButton>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState, mapActions } from 'vuex'

function validateEmail(email) {
  const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return re.test(String(email).toLowerCase())
}

export default {
  name: 'ShoppingList',
  data () {
    return {
      template: '',
      sendingEmail: false
    }
  },
  computed: {
    ...mapState(['emailSetup', 'shoppingListEmail']),
    ...mapGetters(['shoppingList', 'setup']),
    disableSendEmail () {
      return this.sendingEmail || !this.emailSetup || this.template.trim() === ''
    }
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
      if (!validateEmail(this.shoppingListEmail)) {
        this.$notify({
          group: 'app-notifications',
          title: 'Invalid email!',
          type: 'error',
        })
        return
      }
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
          title: 'Failed to save settings!',
          type: 'error',
        })
      })
    },
    sendShoppingList () {
      if (!validateEmail(this.shoppingListEmail)) {
        this.$notify({
          group: 'app-notifications',
          title: 'Invalid email!',
          type: 'error',
        })
        return
      }
      this.sendingEmail = true
      this.$http.secured.get('/send_shopping_list', {
        params: {
          email_content: this.template,
          shopping_list_email: this.shoppingListEmail
        }
      })
      .then(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Email sent!',
          type: 'success',
        })
      }).catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to send email',
          type: 'error',
        })
      }).finally(() => {
        this.sendingEmail = false
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
