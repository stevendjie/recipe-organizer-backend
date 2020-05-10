<template>
  <BCard no-body class="mb-1">
    <BCardHeader header-tag="header" class="p-1" role="tab">
      <div>
      <BButton block v-b-toggle="accordionId" variant="primary" class="acc-title">
        {{ title }} | {{ readyInMinutes || 0 }}m
      </BButton>
      </div>
      <div class="edit-controls mt-1">
        <BButton variant="light" size="sm">Edit <BBadge :variant="editMode ? 'success' : 'danger'" class="ml-1">{{ editMode ? 'ON' : 'OFF' }}</BBadge></BButton>
        <BButton variant="light" size="sm">Save</BButton>
        <BButton variant="light" size="sm">Delete</BButton>
      </div>
    </BCardHeader>
    <BCollapse :id="accordionId" :visible="accVisible" @input="onVisibleChanged" :accordion="accordionId" role="tabpanel">
      <BCardBody>
        <BCard class="mb-2">
          <BCardText>
            Source: <BLink :href="sourceUrl" target="_blank">{{ sourceUrl }}</BLink>
            <Ingredients :ingredients="ingredients" />
          </BCardText>
        </BCard>
      </BCardBody>
    </BCollapse>
  </BCard>
</template>

<script>
import Ingredients from './ingredients/Ingredients.vue'

export default {
  name: 'Recipe',
  components: {
    Ingredients
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
      required: false
    },
    scaleFactor: {
      type: Number,
      required: true,
    },
    ingredients: {
      type: Array
    }
  },
  computed: {
    accordionId () {
      return `accordion-${this.id}`
    }
  },
  methods: {
    onVisibleChanged(visible) {
      this.$emit('update-visible', { visible, id: this.id })
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