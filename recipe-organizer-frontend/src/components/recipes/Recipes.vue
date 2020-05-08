<template>
  <div>
    <h1>Recipes</h1>

    <div class="mt-3">
      <label>Source URL</label>
      <BFormInput v-model="newRecipeSourceUrl" placeholder="Enter URL to import recipe from" class="mb-3"></BFormInput>
      <BButton :disabled="disableAddRecipe" @click="addRecipe" class="mr-2">Add Recipe</BButton>
    </div>

    <div class="mt-3">
      <div v-for="recipe in recipes" :key="recipe.id" class="mb-3">
        <RecipeAccordion
          :id="recipe.id"
          :title="recipe.title"
          :ready-in-minutes="recipe.readyInMinutes"
          :source-url="recipe.sourceUrl"
          :initially-visible="recipe.isNew"
          :edit-mode="recipe.editMode"
        />
      </div>
    </div>
  </div>
</template>

<script>
import RecipeAccordion from './recipe-accordion/RecipeAccordion.vue'

function constructRecipe(data, isNew = false) {
  // eslint-disable-next-line
  const { id, title, source_url, ready_in_minutes, scale_factor, ingredients, equipment, notes, instructions } = data
  return {
    id,
    title,
    sourceUrl: source_url,
    readyInMinutes: ready_in_minutes,
    scaleFactor: scale_factor,
    ingredients,
    equipment,
    notes,
    instructions,
    isNew
  }
}
export default {
  name: 'Recipes',
  data () {
    return {
      recipes: [],
      newRecipeSourceUrl: '',
      disableAddRecipe: false
    }
  },
  components: {
    RecipeAccordion
  },
  created () {
    if (localStorage.signedIn) {
      this.$http.secured.get('/api/v1/recipes/')
      .then((resp) => {
        this.recipes = resp.data.map(recipe => constructRecipe(recipe))
      })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    addRecipe () {
      this.disableAddRecipe = true
      this.$http.secured.post('/api/v1/recipes/', {
        recipe: {
          title: `Recipe ${this.recipes.length + 1}`,
          source_url: this.newRecipeSourceUrl
        }
      }).then((resp) => {
        this.recipes.unshift(constructRecipe(resp.data, true))
        this.disableAddRecipe = false
      })
    }
  }
}
</script>

<style scoped>

</style>
