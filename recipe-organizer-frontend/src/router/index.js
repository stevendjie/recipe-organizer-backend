import Vue from 'vue'
import Router from 'vue-router'
import Login from '@/components/login/Login.vue'
import Signup from '@/components/login/Signup.vue'
import Recipes from '@/components/recipes/Recipes.vue'
import ShoppingList from '@/components/shopping-list/ShoppingList.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Login',
      component: Login
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/recipes',
      name: 'Recipes',
      component: Recipes
    },
    {
      path: '/shopping-list',
      name: 'ShoppingList',
      component: ShoppingList
    }
  ],
  mode: 'history'
})
