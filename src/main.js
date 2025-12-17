import { createApp } from 'vue'
import App from './App.vue'

import { createMemoryHistory, createRouter } from 'vue-router'

import HomeView from '@/components/HomeView.vue';
import CreateView from "@/components/CreateView.vue";

const routes = [
    { path: '/', component: HomeView },
    { path: '/create', component: CreateView },
]

export const router = createRouter({
    history: createMemoryHistory(),
    routes,
})

const app = createApp(App)
app.use(router).mount('#app')

