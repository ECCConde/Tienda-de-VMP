<template>
  <div id="app">
    <Header />
    <ProductList />
    <Notification />
  </div>
</template>

<script>
import Header from './components/Header.vue';
import ProductList from './components/ProductList_new.vue';
import Notification from './components/Notification.vue';

export default {
  components: {
    Header,
    ProductList,
    Notification,
  },
};
</script>

<style>
#app {
  min-height: 100vh;
}
</style>
