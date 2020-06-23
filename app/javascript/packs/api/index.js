import store from '../store'
import Vue from 'vue'
import axios from 'axios'
import VueAxios from 'vue-axios'

axios.interceptors.response.use(function (response) {
    return response.data
})

Vue.use(VueAxios, axios)

function request (method, url, data = null) {
    return axios[method](url, data)
}

export function getPolygons () {
    return request('get', '/api/polygons')
}

export function addPolygons (data) {
    return request('post', '/api/polygons', data)
}

export function deletePolygon (id) {
    return request('delete', `/api/polygons/${id}`)
}
