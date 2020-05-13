<template>
  <BListGroup>
    <BTable responsive :small="true" striped :items="instructionItems" :fields="instructionFields">
        <template v-slot:cell(delete)="data">
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="danger" @click="deleteInstruction(data)">
            x
          </BButton>
        </template>
        <template v-slot:cell(number)="data">
          {{ data.index + 1 }}
        </template>
        <template v-slot:cell(text)="data">
          <BFormTextarea v-show="editMode" :value="data.value" @input="updateInstr($event, data)" type="text"/>
          {{ editMode ? '' : data.value }}
        </template>
        <template v-slot:cell(add)="data">
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="success" @click="addInstruction(data)">
            +
          </BButton>
        </template>
        <template v-slot:table-colgroup="scope">
          <col
            v-for="field in scope.fields"
            :key="field.key"
            :class="{ 'button-badge-width': field.key === 'delete' || field.key === 'add' }"
          >
        </template>
    </BTable>
  </BListGroup>
</template>

<script>
export default {
  name: 'Instructions',
  props: {
    instructions: {
      type: Array,
      required: true
    },
    editMode: {
      type: Boolean,
      required: true
    }
  },
  data() {
    return {
      fields: [{ key: 'delete', label: '', class: 'button-badge-width' }, { key: 'add', label: '', class: 'button-badge-width' }, { key: 'number', label: '#' }, { key: 'text', label: 'Instruction' }]
    }
  },
  computed: {
    instructionItems() {
      return this.instructions.map((instr) => {
        const filteredInstr = {}
        this.instructionFields.forEach((f) => {
          if (instr[f.key] !== undefined) {
            filteredInstr[f.key] = instr[f.key] 
          }
        })
        return filteredInstr
      })
    },
    instructionFields () {
      return !this.editMode ? this.fields.filter(f => f.key !== 'delete' && f.key !== 'add') : this.fields.filter(f => f.key !== 'number')
    }
  },
  methods: {
    addInstruction ({ index }) {
      this.$emit('update-instruction', { text: '' }, index, true)
    },
    deleteInstruction ({ index }) {
      this.$emit('update-instruction', {}, index)
    },
    updateInstr (text, { index }) {
      this.$emit('update-instruction', { text }, index, false)
    }
  }
}
</script>

<style scoped>
.button-badge {
  padding-top: 0.125rem;
  padding-bottom: 0.125rem;
}
.button-badge-width {
  width: 4%;
}
/deep/ .table th, /deep/ .table td {
  vertical-align: middle;
}
</style>
