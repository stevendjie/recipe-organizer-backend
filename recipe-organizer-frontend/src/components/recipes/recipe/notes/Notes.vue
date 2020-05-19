<template>
  <div>
    <BButton class="mt-2" block variant="light" @click="show = !show" size="sm">
      {{ show ? 'Hide' : 'Show' }} Notes
    </BButton>
    <div v-show="show">
      <BTable responsive :small="true" striped :items="notesItems" :fields="notesFields">
        <template v-slot:cell(delete)="data">
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="outline-danger" @click="deleteNote(data)">
            x
          </BButton>
        </template>
        <template v-slot:cell(number)="data">
          {{ data.index + 1 }}
        </template>
        <template v-slot:cell(text)="data">
          <BFormTextarea v-show="editMode" :value="data.value" @input="updateNote($event, data)" type="text"/>
          {{ editMode ? '' : data.value }}
        </template>
        <template v-slot:cell(add)="data">
          <BButton size="sm" class="button-badge" :disabled="!editMode" variant="outline-dark" @click="addNote(data)">
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
      <BButton :disabled="!editMode" block size="sm" v-show="notesItems.length === 0" variant="outline-dark" @click="addNote({ index: -1 })">
        Add Note
      </BButton>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Notes',
  props: {
    notes: {
      type: Array,
      required: true
    },
    editMode: {
      type: Boolean,
      required: true
    }
  },
  data () {
    return {
      show: false,
      fields: [{ key: 'delete', label: '', class: 'button-badge-width' }, { key: 'add', label: '', class: 'button-badge-width' }, { key: 'number', label: '#' }, { key: 'text', label: 'Note' }]
    }
  },
  computed: {
    notesItems () {
      return this.notes
    },
    notesFields () {
      return !this.editMode ? this.fields.filter(f => f.key !== 'delete' && f.key !== 'add') : this.fields.filter(f => f.key !== 'number')
    }
  },
  methods: {
    addNote ({ index }) {
      this.$emit('update-note', { text: '' }, index, true)
    },
    deleteNote ({ index }) {
      this.$emit('update-note', {}, index)
    },
    updateNote (text, { index }) {
      this.$emit('update-note', { text }, index, false)
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