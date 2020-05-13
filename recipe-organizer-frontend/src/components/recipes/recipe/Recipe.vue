<template>
  <BCard no-body class="mb-1">
    <BCardHeader header-tag="header" class="p-1" role="tab">
      <div>
      <BButton block v-b-toggle="accordionId" variant="primary" class="acc-title">
        {{ title }} | {{ readyInMinutes || 0 }}m
      </BButton>
      </div>
      <div class="edit-controls mt-1">
        <BButton variant="light" size="sm" @click="onClickEditButton">Edit <BBadge :variant="editMode ? 'success' : 'danger'" class="ml-1">{{ editMode ? 'ON' : 'OFF' }}</BBadge></BButton>
        <BButton variant="light" size="sm">Save</BButton>
        <BButton variant="light" size="sm" @click="deleteRecipe">Delete</BButton>
      </div>
    </BCardHeader>
    <BCollapse :id="accordionId" :visible="accVisible" @input="onClickAccordionHeader" :accordion="accordionId" role="tabpanel">
      <BCardBody>
        <BCard class="mb-2">
          <BCardText>
            <div>
              <label>Source:
              </label>
              <BFormInput class="mb-2" v-if="editMode" :value="sourceUrl" type="text">
              </BFormInput>
              <BLink v-else :href="sourceUrl" target="_blank">
                {{ sourceUrl }}
              </BLink>
            </div>
            <div :class="{ 'text-center' : !editMode }">
              <label>Multiply By: </label>
              <strong>
                <BFormInput class="mb-2" type="number" v-show="editMode" :value="scaleFactor" @input="updateScaleFactor"/>
                {{ editMode ? '' : scaleFactor }}
              </strong>
            </div>
            <BButton block variant="light" @click="toggleScale" size="sm">{{ scale ? 'Hide' : 'Show' }} Scaled Amounts</BButton>
            <Ingredients
              :ingredients="ingredients"
              :scale-factor="scaleFactor"
              :show-scaled="scale"
              :edit-mode="editMode"
              @update-ingredient="updateIngredient"
            />
            <Instructions
              :instructions="instructions"
              :edit-mode="editMode"
              @update-instruction="updateInstruction"
            />
          </BCardText>
        </BCard>
      </BCardBody>
    </BCollapse>
  </BCard>
</template>

<script>
import Ingredients from './ingredients/Ingredients.vue'
import Instructions from './instructions/Instructions.vue'

export default {
  name: 'Recipe',
  components: {
    Ingredients,
    Instructions
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
    }
  },
  data () {
    return {
      scale: false
    }
  },
  computed: {
    accordionId () {
      return `accordion-${this.id}`
    }
  },
  methods: {
    deleteRecipe() {
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
    updateScaleFactor (scaleFactor) {
      scaleFactor = Number(scaleFactor)
      this.$store.dispatch('updateRecipe', { id: this.id, scaleFactor })
    },
    updateIngredient (ingrData, index) {
      const { ingredients } = this
      if (index === ingredients.length) { // new
        ingrData.shoppingListIndex = null
        ingredients.push(ingrData)
      } else if (Object.keys(ingrData).length === 0) { // delete
        ingredients.splice(index, 1)
      } else { // update
        ingrData.shoppingListIndex = null // TODO: need to change
        ingredients[index] = Object.assign(ingredients[index], ingrData)
      }
      this.$store.dispatch('updateRecipe', { id: this.id, ingredients })
    },
    updateInstruction (instrData, index, isNew = false) {
      const { instructions } = this
      if (Object.keys(instrData).length === 0) { // delete
        instructions.splice(index, 1)
      } else if (isNew) { // new
        instructions.splice(index + 1, 0, instrData)
      } else { // update
        instructions[index] = Object.assign(instructions[index], instrData)
      }
      this.$store.dispatch('updateRecipe', { id: this.id, instructions })
    },
    toggleScale () {
      this.scale = !this.scale
    }
  }
}

</script>

<style scoped>
.edit-controls {
  width: 100%;
  display: flex;
  justify-content: center;
}
</style>