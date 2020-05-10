<template>
  <BTable striped :items="ingredientItems" :fields="ingredientFields">
    <template v-slot:cell(inShoppingList)="data">
      <BBadge v-if="data.value" variant="success">Added</BBadge>
      <BBadge v-else variant="warning">Not Added</BBadge>
    </template>
  </BTable>
</template>
<script>
export default {
  name: 'Ingredients',
  props: {
    ingredients: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      ingredientFields: [{ key: 'amount' }, { key: 'unit' }, { key: 'name' }, { key: 'inShoppingList', label: 'Shopping List' }]
    }
  },
  computed: {
    ingredientItems () {
      return this.ingredients.map((ingr) => {
        const filteredIngr = {}
        this.ingredientFields.forEach((f) => {
          filteredIngr[f.key] = ingr[f.key] 
        })
        return filteredIngr
      })
    }
  }
}
</script>
