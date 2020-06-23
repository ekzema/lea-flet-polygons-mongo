import Vue from 'vue'
import Vuex from 'vuex'
import * as api from '../api'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  },
  mutations: {
  },
  actions: {
    getPolygons () {
      return api.getPolygons()
    },
    addPolygons ({ commit }, data) {
      return api.addPolygons(data)
    },
    deletePolygon ({ commit }, id) {
      return api.deletePolygon(id)
    }
  },
  modules: {
  }
})
