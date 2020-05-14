<template>
  <div>
    <BButton block variant="light" @click="show = !show" size="sm">{{ show ? 'Hide' : 'Show' }} Equipment</BButton>
    <div v-show="show">
      <BTable v-show="show" responsive class="mt-2" :small="true" striped :items="eqItems" :fields="eqFields">
        <template v-slot:cell(inShoppingList)="data">
          <BButton
            block
            size="sm"
            class="button-badge"
            :variant="data.value ? 'success' : 'warning'"
            :disabled="!editMode"
            @click="updateEqAttr(!data.value, data)"
          >
            {{ data.value ? 'Added' : 'Not Added' }}
          </BButton>
        </template>
        <template v-slot:cell(delete)="data">
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="danger" @click="deleteEquipment(data)">
            x
          </BButton>
        </template>
        <template v-slot:table-colgroup="scope">
          <col
            v-for="field in scope.fields"
            :key="field.key"
            :class="{ 'controls-button-width': field.key === 'delete', 'shopping-button-width': field.key === 'inShoppingList' }"
          >
        </template>
        <template v-slot:cell(name)="data">
          <BFormInput v-show="editMode" :value="data.value" @input="updateEqAttr($event, data)" type="text" />
          {{ editMode ? '' : data.value }}
        </template>
      </BTable>
      <BButton block size="sm" variant="outline-primary" :disabled="!editMode" @click="addEquipment">
        Add Equipment
      </BButton>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Equipment',
  props: {
    editMode: {
      type: Boolean,
      required: true
    },
    equipment: {
      type: Array,
      required: true
    }
  },
  data () {
    return {
      show: false
    }
  },
  computed: {
    eqItems () {
      return this.equipment
    },
    eqFields () {
      const fields = [{ key: 'name', label: 'Equipment' }, { key: 'inShoppingList', label: 'Shopping List' }]
      if (this.editMode) {
        fields.unshift({ key: 'delete', label: '', thStyle: { 'max-width': '35px' } })
      }
      return fields
    }
  },
  methods: {
    addEquipment () {
      this.$emit('update-equipment', { name: '', inShoppingList: false }, this.equipment.length)
    },
    deleteEquipment ({ index }) {
      this.$emit('update-equipment', { }, index)
    },
    updateEqAttr (value, { field, index }) {
      const attr = field.key
      this.$emit('update-equipment', { [attr]: value }, index)
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
