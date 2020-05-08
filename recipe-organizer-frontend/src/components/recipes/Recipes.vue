<template>
  <div>
    <h1>Recipes</h1>

    <div class="mt-3">
      <label>Source URL</label>
      <BFormInput v-model="newRecipeSourceUrl" placeholder="Enter URL to import recipe from" class="mb-3"></BFormInput>
      <BButton @click="addRecipe" class="mr-2">Add Recipe</BButton>
    </div>

    <div class="mt-3">
      <div v-for="recipe in recipes" :key="recipe.id" class="mb-3">
        <RecipeAccordion
          :title="recipe.title"
          :ready-in-minutes="recipe.readyInMinutes"
          :source-url="recipe.sourceUrl"
          :initially-visible="recipe.new"
          :edit-mode="recipe.editMode"
        />
      </div>
    </div>
  </div>
</template>

<script>
import RecipeAccordion from './recipe-accordion/RecipeAccordion.vue'

export default {
  name: 'Recipes',
  data () {
    return {
      recipes: [],
      newRecipeSourceUrl: ''
    }
  },
  components: {
    RecipeAccordion
  },
  methods: {
    addRecipe () {
      this.$http.secured.post('/api/v1/recipes/', {
        recipe: {
          title: `Recipe ${this.recipes.length + 1}`,
          source_url: this.newRecipeSourceUrl
        }
      }).then((resp) => {
        // eslint-disable-next-line
        const { title, source_url, ready_in_minutes, scale_factor, ingredients, equipment, notes, instructions } = resp.data
        this.recipes.unshift({
          title,
          sourceUrl: source_url,
          readyInMinutes: ready_in_minutes,
          scaleFactor: scale_factor,
          ingredients,
          equipment,
          notes,
          instructions
        })
        
      })
    }
  }
}
</script>

<style scoped>

</style>
