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

function convertNumbers(arr) {
  return arr.map(el => {
    el.amount = Number(el.amount)
    return el
  })
}

function addIndices(arr) {
  return arr.map((el, index) => {
    el.index = index
    return el
  })
}

export const store = new Vuex.Store({
  state: {
    recipes: [],
    shoppingListEmail: null,
    recipesSetup: false,
    settingsSetup: false
  },
  getters: {
    shoppingList: (state) => {
      let shoppingList = [];
      state.recipes.forEach((recipe) => {
        function createShoppingList (items, isIngredient)  {
          return items.filter(i => i.inShoppingList).map(r => {
            const item = { isIngredient }
            item.name = r.name
            item.order = r.shoppingListIndex
            return item
          })
        }
        shoppingList = shoppingList.concat(createShoppingList(recipe.ingredients, true)).concat(createShoppingList(recipe.equipment, false))
      })
      return shoppingList
    },
    setup: state => state.recipesSetup && state.settingsSetup
  },
  mutations: {
    setRecipes (state, recipes) {
      state.recipes = recipes
    },
    setShoppingListEmail (state, email) {
      state.shoppingListEmail = email
    },
    setRecipesSetup (state) {
      state.recipesSetup = true
    },
    setSettingsSetup (state) {
      state.settingsSetup = true
    }
  },
  actions: {
    setupSettings ({ commit }) {
      return this._vm.$http.secured.get('/settings')
      .then((resp) => {
        const { shopping_list_email } = resp.data
        commit('setShoppingListEmail', shopping_list_email)
        commit('setSettingsSetup')
      })
    },
    setupRecipes ({ commit }) {
      this._vm.$http.secured.get('/api/v1/recipes/')
      .then((resp) => {
        commit('setRecipes', resp.data.map(r => constructRecipe(r)))
        commit('setRecipesSetup')
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
    saveRecipe ({ state }, { id }) {
      const recipe = state.recipes.find(r => r.id === id)
      return this._vm.$http.secured.patch(`/api/v1/recipes/${id}`, {
        recipe: {
          title: recipe.title,
          source_url: recipe.sourceUrl,
          ready_in_minutes: Number(recipe.readyInMinutes),
          scale_factor: Number(recipe.scaleFactor),
          ingredients: convertNumbers(recipe.ingredients),
          equipment: recipe.equipment,
          notes: addIndices(recipe.notes),
          instructions: addIndices(recipe.instructions)
        }
      })
    },
    updateRecipe ({ commit, state }, recipeData) {
      const { recipes } = state
      const idx = recipes.findIndex(r => r.id === recipeData.id)
      recipes[idx] = Object.assign(recipes[idx], recipeData)
      commit('setRecipes', recipes)
    },
    updateShoppingListEmail ({ commit }, email) {
      commit('setShoppingListEmail', email)
    },
    saveSettings ({ commit, state }) {
      return this._vm.$http.secured.patch('/settings', {
        settings: {
          shopping_list_email: state.shoppingListEmail
        }
      })
    }
  }
})