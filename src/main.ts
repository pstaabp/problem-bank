import { createApp } from 'vue';
import { Quasar, Notify } from 'quasar';
import { createRouter, createWebHistory } from 'vue-router';
import { createPinia } from 'pinia';
import routes from './router/routes';
// import router from './router';

// Import icon libraries
import '@quasar/extras/material-icons/material-icons.css';

// Import Quasar css
import 'quasar/src/css/index.sass';

// Assumes your root component is App.vue
// and placed in same folder as main.ts
import App from './App.vue';

const router = createRouter({
	history: createWebHistory(),
	routes
});

const pinia = createPinia();

const myApp = createApp(App).use(router).use(pinia);

// For notifications
myApp.use(Quasar, { plugins: { Notify } });

// Assumes you have a <div id="app"></div> in your index.html
myApp.mount('#app');