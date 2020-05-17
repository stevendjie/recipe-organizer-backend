<template>
  <BCard no-body class="mb-1">
    <BCardHeader header-tag="header" class="p-1" role="tab">
      <div>
        <BButton block v-b-toggle="accordionId" variant="dark" class="acc-title">
          {{ title }} | {{ readyInMinutes || 0 }}m
          <BBadge variant="warning" class="ml-1" v-show="dirty">UNSAVED CHANGES</BBadge>
        </BButton>
      </div>
      <div class="edit-controls d-flex justify-content-center mt-1">
        <BButton variant="light" size="sm" @click="onClickEditButton">Edit <BBadge :variant="editMode ? 'success' : 'warning'" class="ml-1">{{ editMode ? 'ON' : 'OFF' }}</BBadge></BButton>
        <BButton variant="light" size="sm" @click="saveRecipe">Save</BButton>
        <BButton variant="light" size="sm" @click="deleteRecipe">Delete</BButton>
      </div>
    </BCardHeader>
    <BCollapse :id="accordionId" :visible="accVisible" @input="onClickAccordionHeader" :accordion="accordionId" role="tabpanel">
      <BCardBody>
        <BTabs content-class="mt-3">
          <BTab title="Information" active>
            <div>
              <label class="font-weight-bold">
                Source:
              </label>
              <BFormInput class="mb-2" v-if="editMode" :value="sourceUrl" @input="updateRecipeAttr($event, 'sourceUrl')" type="text">
              </BFormInput>
              <BLink v-else :href="sourceUrl" target="_blank">
                {{ sourceUrl }}
              </BLink>
            </div>
            <div>
              <label class="font-weight-bold">
                Recipe Name:
              </label>
              <BFormInput class="mb-2" v-if="editMode" :value="title" @input="updateRecipeAttr($event, 'title')" type="text">
              </BFormInput>
              {{ !editMode ? title : '' }}
            </div>
            <div>
              <label class="font-weight-bold">
                Time Required:
              </label>
              <BFormInput class="mb-2" v-if="editMode" :value="readyInMinutes" @input="updateRecipeAttr($event, 'readyInMinutes')" type="text">
              </BFormInput>
              {{ !editMode ? (readyInMinutes || 0) : '' }}<span v-show="!editMode">m</span>
            </div>
          </BTab>
          <BTab title="Ingredients & Equipment">
            <div :class="{ 'text-center' : !editMode }">
              <label>Multiply By: </label>
              <strong>
                <BFormInput class="mb-2" type="number" v-show="editMode" :value="scaleFactor" @input="updateRecipeAttr($event, 'scaleFactor')"/>
                {{ editMode ? '' : scaleFactor }}
              </strong>
            </div>
            <BButton block variant="light" @click="scale = !scale" size="sm">{{ scale ? 'Hide' : 'Show' }} Scaled Amounts</BButton>
            <Ingredients
              :ingredients="ingredients"
              :scale-factor="scaleFactor"
              :show-scaled="scale"
              :edit-mode="editMode"
              @update-ingredient="updateIngredient"
            />
            <Equipment
              :equipment="equipment"
              :edit-mode="editMode"
              @update-equipment="updateEquipment"
            />
          </BTab>
          <BTab title="Instructions & Notes">
            <Instructions
              :instructions="instructions"
              :edit-mode="editMode"
              @update-instruction="updateInstruction"
            />
            <Notes 
              :notes="notes"
              :edit-mode="editMode"
              @update-note="updateNote"
            />
          </BTab>
        </BTabs>
      </BCardBody>
    </BCollapse>
  </BCard>
</template>

<script>
import { mapGetters } from 'vuex'
import Ingredients from './ingredients/Ingredients.vue'
import Instructions from './instructions/Instructions.vue'
import Equipment from './equipment/Equipment.vue'
import Notes from './notes/Notes.vue'

export default {
  name: 'Recipe',
  components: {
    Ingredients,
    Instructions,
    Equipment,
    Notes
  },
  props: {
    id: {
      type: Number,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    readyInMinutes: {
      type: Number,
      default: null
    },
    sourceUrl: {
      type: String,
      default: null
    },
    accVisible: {
      type: Boolean,
      required: true
    },
    editMode: {
      type: Boolean,
      required: true
    },
    scaleFactor: {
      type: Number,
      required: true,
    },
    ingredients: {
      type: Array,
      required: true
    },
    instructions: {
      type: Array,
      required: true
    },
    equipment: {
      type: Array,
      required: true
    },
    notes: {
      type: Array,
      required: true
    }
  },
  data () {
    return {
      scale: false,
      dirty: false
    }
  },
  computed: {
    ...mapGetters(['shoppingList']),
    accordionId () {
      return `accordion-${this.id}`
    }
  },
  methods: {
    deleteRecipe () {
      this.$store.dispatch('deleteRecipe', { id: this. id })
      .then(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Successfully deleted recipe!',
          type: 'success',
        })
      }).catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to delete recipe!',
          type: 'error',
        })
      })
    },
    saveRecipe () {
      this.$store.dispatch('saveRecipe', { id: this.id })
      .then(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Successfully updated recipe!',
          type: 'success',
        })
      }).catch(() => {
        this.$notify({
          group: 'app-notifications',
          title: 'Failed to update recipe!',
          type: 'error',
        })
      })
    },
    onClickAccordionHeader (visible) {
      if (!visible) {
        this.$emit('update-edit-mode', { editMode: false, id: this.id })
      }
      this.$emit('update-visible', { visible, id: this.id })
    },
    onClickEditButton () {
      if (!this.editMode && !this.accVisible) {
        this.$emit('update-visible', { visible: true, id: this.id })
      }
      this.$emit('update-edit-mode', { editMode: !this.editMode, id: this.id })
    },
    updateShoppingListEntity (data, index, entityName) {
      const entity = this[entityName]
      if (index === entity.length) { // new
        data.shoppingListIndex = null
        entity.push(data)
      } else if (Object.keys(data).length === 0) { // delete
        entity.splice(index, 1)
      } else { // update
        if (data.inShoppingList) {
          data.shoppingListIndex = this.shoppingList.length 
        } else if (data.inShoppingList === false) {
          data.shoppingListIndex = null;
        }
        entity[index] = Object.assign(entity[index], data)
      }
      this.updateRecipe({ id: this.id, [entityName]: entity })
    },
    updateInstructiveEntity (instrData, index, isNew, entityName) {
      const entity = this[entityName]
      if (Object.keys(instrData).length === 0) { // delete
        entity.splice(index, 1)
      } else if (isNew) { // new
        entity.splice(index + 1, 0, instrData)
      } else { // update
        entity[index] = Object.assign(entity[index], instrData)
      }
      this.updateRecipe({ id: this.id, [entityName]: entity })
    },
    updateEquipment (eqData, index) {
      this.updateShoppingListEntity(eqData, index, 'equipment')
    },
    updateIngredient (ingrData, index) {
      this.updateShoppingListEntity(ingrData, index, 'ingredients')
    },
    updateNote (noteData, index, isNew = false) {
      this.updateInstructiveEntity(noteData, index, isNew, 'notes')
    },
    updateInstruction (instrData, index, isNew = false) {
      this.updateInstructiveEntity(instrData, index, isNew, 'instructions')
    },
    updateRecipeAttr (value, key) {
      if (key === 'scaleFactor') {
        value = Number(value)
      }
      this.updateRecipe({ id: this.id, [key]: value })
    },
    updateRecipe (payload) {
      this.dirty = true
      this.$store.dispatch('updateRecipe', payload)
    }
  }
}
</script>

<style scoped>
.edit-controls {
  width: 100%;
}
</style>