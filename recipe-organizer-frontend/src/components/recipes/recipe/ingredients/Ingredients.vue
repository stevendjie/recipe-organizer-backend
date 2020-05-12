<template>
  <div>
    <div class="ingredient-container">
      <BTable responsive class="mt-2 raw" striped :items="ingredientItems" :fields="ingredientFields">
        <template v-slot:cell(inShoppingList)="data">
          <BButton
            block
            size="sm"
            class="button-badge"
            :variant="data.value ? 'success' : 'warning'"
            :disabled="!editMode"
            @click="updateIngrAttr(!data.value, data)"
          >
            {{ data.value ? 'Added' : 'Not Added' }}
          </BButton>
        </template>
        <template v-slot:cell(amount)="data">
          <BFormInput v-show="editMode" :value="data.value" @input="updateIngrAttr($event, data)" type="number"/>
          {{ editMode ? '' : data.value }}
        </template>
        <template v-slot:cell(unit)="data">
          <BFormInput v-show="editMode" :value="data.value" @input="updateIngrAttr($event, data)" type="text"/>
          {{ editMode ? '' : data.value }}
        </template>
        <template v-slot:cell(name)="data">
          <BFormInput v-show="editMode" :value="data.value" @input="updateIngrAttr($event, data)" type="text"/>
          {{ editMode ? '' : data.value }}
        </template>
        <template v-slot:cell(delete)="data">
          <BButton block size="sm" class="button-badge" :disabled="!editMode" variant="danger" @click="deleteIngredient(data)">
            X
          </BButton>
        </template>
      </BTable>
      <BButton block size="sm" variant="outline-primary" :disabled="!editMode" @click="addIngredient">
        Add Ingredient
      </BButton>
    </div>
  </div>
</template>
<script>
export default {
  name: 'Ingredients',
  props: {
    ingredients: {
      type: Array,
      required: true
    },
    scaleFactor: {
      type: Number,
      required: true
    },
    editMode: {
      type: Boolean,
      required: true
    },
    showScaled: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      rawFields: [{ key: 'delete', label: '', tdClass: 'vertically-center' }, { key: 'amount' }, { key: 'unit' }, { key: 'name' }, { key: 'inShoppingList', label: 'Shopping List', tdClass: 'vertically-center' }],
      scaledFields: [{ key: 'delete', label: '', tdClass: 'vertically-center' }, { key: 'amount' }, { key: 'scaledAmount', label: 'Amount', variant: 'warning', striped: true }, { key: 'unit' }, { key: 'name' }, { key: 'inShoppingList', label: 'Shopping List', tdClass: 'vertically-center' }]
    }
  },
  computed: {
    ingredientItems () {
      const rawItems = this.ingredients.map((ingr) => {
        const filteredIngr = {}
        this.ingredientFields.forEach((f) => {
          if (ingr[f.key] !== undefined) {
            filteredIngr[f.key] = ingr[f.key] 
          }
        })
        return filteredIngr
      })
      if (this.showScaled) {
        return rawItems.map((ingr) => {
          const scaled = Number(ingr.amount) * this.scaleFactor
          ingr.scaledAmount = parseFloat(scaled.toFixed(2))
          return ingr
        })
      }
      return rawItems
    },
    ingredientFields () {
      return this.showScaled ? this.scaledFields : this.rawFields
    }
  },
  methods: {
    updateIngrAttr(value, { field, index }) {
      const attr = field.key
      this.$emit('update-ingredient', { [attr]: value }, index)
    },
    deleteIngredient({ index }) {
      this.$emit('update-ingredient', {}, index)
    },
    addIngredient() {
      this.$emit('update-ingredient', { amount: '', unit: '', name: '', inShoppingList: false }, this.ingredients.length)
    }
  }
}
</script>

<style scoped>
.button-badge {
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
}
/deep/ .vertically-center {
  vertical-align: middle;
}
</style>