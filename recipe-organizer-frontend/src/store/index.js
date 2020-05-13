import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

function constructRecipe (recipe) {
  function constructIngr(ingr) {
    // eslint-disable-next-line
    const { name, amount, unit, in_shopping_list, shopping_list_index } = ingr
    return {
      name,
      amount: parseFloat(Number(amount).toFixed(2)),
      unit,
      inShoppingList: in_shopping_list,
      shoppingListIndex: shopping_list_index
    }
  }

  function constructEq(eq) {
    // eslint-disable-next-line
    const { name, in_shopping_list, shopping_list_index } = eq
    return {
      name,
      inShoppingList: in_shopping_list,
      shoppingListIndex: shopping_list_index,
    }
  }

  function constructInstr(instr) {
    const { text } = instr
    return {
      text
    }
  }

  // eslint-disable-next-line
  const { id, title, source_url, ready_in_minutes, scale_factor, ingredients, equipment, notes, instructions } = recipe
  return {
    id,
    title,
    sourceUrl: source_url,
    readyInMinutes: ready_in_minutes,
    scaleFactor: Number(scale_factor),
    ingredients: ingredients.map(ingr => constructIngr(ingr)),
    equipment: equipment.map(eq => constructEq(eq)),
    notes: notes.map(note => constructInstr(note)),
    instructions: instructions.map(instr => constructInstr(instr))
  }
}

export const store = new Vuex.Store({
  state: {
    recipes: []
  },
  mutations: {
    setRecipes (state, recipes) {
      state.recipes = recipes
    } 
  },
  actions: {
    setup ({ commit }) {
      return this._vm.$http.secured.get('/api/v1/recipes/')
      .then((resp) => {
        commit('setRecipes', resp.data.map(r => constructRecipe(r)))
      })
    },
    prependRecipe ({ commit, state }, { sourceUrl }) {
      return this._vm.$http.secured.post('/api/v1/recipes/', {
        recipe: {
          title: `Recipe ${state.recipes.length + 1}`,
          source_url: sourceUrl
        }
      }).then((resp) => {
        const { recipes } = state
        recipes.unshift(constructRecipe(resp.data, true))
        commit('setRecipes', recipes)
        return resp.data.id
      })
    },
    deleteRecipe ({ commit, state }, { id }) {
      return this._vm.$http.secured.delete(`/api/v1/recipes/${id}`)
      .then(() => commit('setRecipes', state.recipes.filter(r => r.id !== id)))
    },
    updateRecipe ({ commit, state }, recipeData) {
      const { recipes } = state
      const idx = recipes.findIndex(r => r.id === recipeData.id)
      recipes[idx] = Object.assign(recipes[idx], recipeData)
      commit('setRecipes', recipes)
    }
  }
})