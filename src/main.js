import { createApp } from 'vue';
import App from './App.vue';
import store from './store';
import './design-system.css';
import './animations.css';
import './styles.css';

createApp(App).use(store).mount('#app');