<template>
  <div>
    <div class="ingredient-container">
      <BTable responsive class="mt-2" :small="true" striped :items="ingredientItems" :fields="ingredientFields">
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
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="danger" @click="deleteIngredient(data)">
            x
          </BButton>
        </template>
        <template v-slot:table-colgroup="scope">
          <col
            v-for="field in scope.fields"
            :key="field.key"
            :class="{ 'controls-button-width': field.key === 'delete', 'shopping-button-width': field.key === 'inShoppingList' }"          >
        </template>
      </BTable>
      <BButton block class="mb-3" size="sm" variant="outline-primary" :disabled="!editMode" @click="addIngredient">
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
      rawFields: [{ key: 'delete', label: '' }, { key: 'amount' }, { key: 'unit' }, { key: 'name', label: 'Ingredient' }, { key: 'inShoppingList', label: 'Shopping List' }],
      scaledFields: [{ key: 'delete', label: '' }, { key: 'amount' }, { key: 'scaledAmount', label: 'Amount', variant: 'warning', striped: true }, { key: 'unit' }, { key: 'name', label: 'Ingredient' }, { key: 'inShoppingList', label: 'Shopping List' }]
    }
  },
  computed: {
    ingredientItems () {
      if (this.showScaled) {
        return this.ingredients.map((ingr) => {
          const scaled = Number(ingr.amount) * this.scaleFactor
          ingr.scaledAmount = parseFloat(scaled.toFixed(2))
          return ingr
        })
      }
      return this.ingredients
    },

    ingredientFields () {
      return this.showScaled ? this.filterButtons(this.scaledFields) : this.filterButtons(this.rawFields)
    }
  },
  methods: {
    updateIngrAttr(value, { field, index }) {
      const attr = field.key
      if (attr === 'amount') {
        value = Number(value)
      }
      this.$emit('update-ingredient', { [attr]: value }, index)
    },
    deleteIngredient({ index }) {
      this.$emit('update-ingredient', {}, index)
    },
    addIngredient() {
      this.$emit('update-ingredient', { amount: '', unit: '', name: '', inShoppingList: false }, this.ingredients.length)
    },
    filterButtons (arr)  {
      return !this.editMode ? arr.filter(f => f.key !== 'delete') : arr
    }
  }
}
</script>

<style scoped>
.button-badge {
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
}
/deep/ .table th, /deep/ .table td {
  vertical-align: middle;
}
.controls-button-width {
  width: 4%;
}
.shopping-button-width {
  width: 15%;
}
</style>