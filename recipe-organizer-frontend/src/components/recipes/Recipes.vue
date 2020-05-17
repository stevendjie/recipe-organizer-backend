<template>
  <div>
    <h1>Recipes</h1>
    <div class="mt-3">
      <label>Source URL</label>
      <BFormInput v-model="newRecipeSourceUrl" placeholder="Enter URL to import recipe from"></BFormInput>
      <p>(Powered by <a target="_blank" href="https://spoonacular.com/food-api">Spoonacular API</a>)</p>
      <BButton variant="outline-dark" :disabled="disableAddRecipe" @click="addRecipe" class="mr-2">Add Recipe</BButton>
    </div>

    <div class="mt-3">
      <div v-for="(recipe, idx) in recipes" :key="recipe.id" class="mb-3">
        <Recipe
          :id="recipe.id"
          :title="recipe.title"
          :ready-in-minutes="recipe.readyInMinutes"
          :source-url="recipe.sourceUrl"
          :ingredients="recipe.ingredients"
          :instructions="recipe.instructions"
          :equipment="recipe.equipment"
          :notes="recipe.notes"
          :scale-factor="recipe.scaleFactor"
          :acc-visible="!!(activeRecipes[recipe.id])"
          :edit-mode="!!(editingRecipes[recipe.id])"
          @update-visible="updateVisible"
          @update-edit-mode="updateEditMode"
        />
      </div>
    </div>
    <div>Icons made by <a target="_blank" href="https://www.flaticon.com/authors/iconixar" title="iconixar">iconixar</a> from <a target="_blank" href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import Recipe from './recipe/Recipe.vue'

export default {
  name: 'Recipes',
  data () {
    return {
      newRecipeSourceUrl: '',
      disableAddRecipe: false,
      activeRecipes: {},
      editingRecipes: {}
    }
  },
  components: {
    Recipe
  },
  computed: {
    ...mapState(['recipes']),
    ...mapGetters(['setup'])
  },
  created () {
    if (localStorage.signedIn) {
      if (this.setup) {
        return;
      }
      this.$store.dispatch('setupSettings').catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to fetch settings',
          type: 'error',
        }) 
      })
      this.$store.dispatch('setupRecipes').catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to fetch recipes',
          type: 'error',
        })    
      })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    addRecipe () {
      this.disableAddRecipe = true
      this.$store.dispatch('prependRecipe', { sourceUrl: this.newRecipeSourceUrl })
      .then((id) => {
        this.$notify({
          group: 'app-notifications',
          title: 'Successfully created recipe!',
          type: 'success',
        })
        this.updateVisible({ visible: true, id })
        this.updateEditMode({ editMode: true, id })
        this.disableAddRecipe = false
      }).catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to create recipe!',
          type: 'error',
        })
        this.disableAddRecipe = false
      })
    },
    updateVisible ({ visible, id }) {
      this.$set(this.activeRecipes, id, visible || undefined)
    },
    updateEditMode ({ editMode, id }) {
      this.$set(this.editingRecipes, id, editMode || undefined)
    }
  }
}
</script>

<style scoped>

</style>
