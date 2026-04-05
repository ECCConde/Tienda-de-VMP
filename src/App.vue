<template>
  <div id="app">
    <Header @toggle-cart="toggleCart" @search="handleSearch" />
    <ProductList ref="productList" :search-query="searchQuery" />
    <Notification />
  </div>
</template>

<script>
import Header from './components/Header_modern.vue';
import ProductList from './components/ProductList_modern.vue';
import Notification from './components/Notification.vue';

export default {
  name: 'App',
  components: {
    Header,
    ProductList,
    Notification,
  },
  data() {
    return {
      searchQuery: ''
    };
  },
  methods: {
    toggleCart() {
      // Toggle cart en ProductList
      if (this.$refs.productList) {
        this.$refs.productList.toggleCartVisibility();
      }
    },
    handleSearch(query) {
      this.searchQuery = query;
    }
  }
};
</script>

<style>
#app {
  min-height: 100vh;
  background: var(--bg-primary);
  transition: background-color var(--transition-base);
}
</style>