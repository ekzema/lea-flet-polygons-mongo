<template>
    <div class="container">
        <div class="row">
            <div class="box1">
                <l-map
                        style="height: 800px; width:800px"
                        ref="map"
                        :zoom="zoom"
                        :center="center"
                >
                    <l-control position="topright">
                        <button :class="countLayers ? 'save_button' : 'save_button_disabled'"
                                @click="savePolygons"
                                :disabled="!(countLayers > 0)"
                        >
                            Save polygons
                        </button>
                    </l-control>
                    <l-tile-layer :url="url"></l-tile-layer>
                    <l-marker :lat-lng="center"></l-marker>
                    <l-polygon :lat-lngs="polygon.latlngs" :color="polygon.color"></l-polygon>
                </l-map>
            </div>
            <div class="box2" v-if="polygon.list.length">
                <ul id="bar_scope">
                    <li v-for="item in polygon.list" :key="item.id">
                        <span class="polygon_created">{{item.created}} | </span>
                        <span class="polygon_delete" @click="deletePolygon(item.id)">delete</span>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>
    import {LMap, LTileLayer, LMarker, LPolygon, LControl} from 'vue2-leaflet'
    import LDraw from 'leaflet-draw'
    export default {
        name: 'home',
        data () {
            return {
                polygonItems: null,
                url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
                zoom: 40,
                countLayers: 0,
                center: [47.838088,  35.124855],
                bounds: null,
                polygon: {
                    latlngs: [],
                    color: 'green',
                    list: []
                },
            }
        },
        components: {
            LMap, LTileLayer, LMarker, LPolygon, LControl
        },
        created () {
            this.getPolygons()
        },
        methods: {
            savePolygons () {
                const result = Object.values(this.polygonItems._layers).map(l => l.toGeoJSON())
                this.$store.dispatch('addPolygons', {data: result}).then(response => {
                    if (response.success) {
                        this.clearPolygons()
                    }
                })
            },
            clearPolygons () {
                this.polygonItems.eachLayer(layer => {
                    this.polygonItems.removeLayer(layer)
                })
                this.getPolygons()
                this.countLayers = 0
            },
            getPolygons () {
                this.$store.dispatch('getPolygons').then(response => {
                    if (response.success) {
                        this.polygon.list = []
                        let coordinates = []
                        response.data.map((polygon) => {
                            this.polygon.list.push({id: polygon._id.$oid, created: polygon.created_at})
                            coordinates.push(polygon.value)
                        })
                        this.polygon.latlngs = coordinates.map(value => value.map(number => number.map(i => i.reverse())))
                    }
                })
            },
            deletePolygon (id) {
                this.$store.dispatch('deletePolygon', id).then(response => {
                    if (response.success) {
                        this.getPolygons()
                    }
                })
            }
        },
        mounted() {
            this.$nextTick(function () {
                const map = this.$refs.map.mapObject
                const drawnItems = new L.FeatureGroup()
                map.addLayer(drawnItems)
                const drawControl = new L.Control.Draw({
                    position: 'topright',
                    draw: {
                        polyline: false,
                        polygon: true,
                        rectangle: false,
                        circle: false,
                        marker: false,
                        circlemarker: false
                    },
                    edit: {
                        featureGroup: drawnItems
                    }
                })
                map.addControl(drawControl)
                map.on(L.Draw.Event.CREATED, (e) => {
                    const layer = e.layer
                    drawnItems.addLayer(layer)
                    this.countLayers++
                })
                map.on(L.Draw.Event.DELETED, (e) => {
                    if (this.countLayers) this.countLayers--
                })
                this.polygonItems = drawnItems
            })
        },
    }
</script>

<style>
    .container {
        background: white;
        width: 100%;
        min-height: 100%;
        border-radius: 5px;
    }

    .row {
        display: flex;
    }
    .box1 {
        flex: 1;
    }

    .box2 {
        outline: 1px solid silver;
        padding: 10px;
        flex: 1;
    }
    #bar_scope{
        padding: 0;
        list-style: none;
    }
    #bar_scope li {
        outline: 1px solid green;
        padding: 7px 5px 7px 5px;
        margin: 7px 0 7px 0;
        transition: all .5s;
    }
    #bar_scope li:hover {
        background-color: #9BCD9C;
    }
    #bar_scope li span {
        font-size: 16px;
    }
    .polygon_delete {
        color: red;
        cursor: pointer;
    }
    .polygon_created {
        cursor: default;
    }
    .save_button:focus{
        outline: none;
    }
    .save_button {
        border-radius: 5px;
        padding: 5px;
        color: white;
        background-color: #28A745;
    }
    .save_button_disabled {
        border-radius: 5px;
        padding: 5px;
        color: black;
        background-color: #F2F2F2;
    }
</style>
