<template>
  <BCard no-body class="mb-1">
    <BCardHeader header-tag="header" class="p-1" role="tab">
      <BButton block href="#" v-b-toggle.accordion-2 variant="primary">{{ title }}</BButton>
    </BCardHeader>
    <BCollapse id="accordion-2" :visible="initiallyVisible" accordion="my-accordion" role="tabpanel">
      <BCardBody>
        Ready In: {{ readyInMinutes }}
        Source URL: {{ sourceUrl }}
      </BCardBody>
    </BCollapse>
  </BCard>
</template>

<script>
export default {
  name: 'RecipeAccordion',
  props: {
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
    initiallyVisible: {
      type: Boolean,
      default: false
    },
    editMode: {
      type: Boolean,
      defaul: false
    }
  }
}

</script>
