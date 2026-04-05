// src/store/index.js

import { createStore } from 'vuex';

// Plugin para persistencia en localStorage
const localStoragePlugin = (store) => {
  // Cargar estado inicial desde localStorage
  const savedState = localStorage.getItem('vmp-store');
  if (savedState) {
    try {
      const state = JSON.parse(savedState);
      store.replaceState(Object.assign(store.state, state));
    } catch (e) {
      console.error('Error loading saved state:', e);
    }
  }

  // Guardar en localStorage cada vez que hay cambios
  store.subscribe((mutation, state) => {
    localStorage.setItem('vmp-store', JSON.stringify({
      isLoggedIn: state.isLoggedIn,
      user: state.user,
      cart: state.cart,
    }));
  });
};

export default createStore({
  state: {
    isLoggedIn: false,
    user: null,
    cart: [],
    notification: null,
  },
  
  getters: {
    cartItemCount(state) {
      return state.cart.reduce((total, item) => total + item.quantity, 0);
    },
    cartTotal(state) {
      return state.cart.reduce((total, item) => total + (item.price * item.quantity), 0);
    },
    getCartItem: (state) => (productId) => {
      return state.cart.find(item => item.id === productId);
    },
  },
  
  mutations: {
    login(state, userData) {
      state.isLoggedIn = true;
      state.user = userData;
    },
    register(state, userData) {
      state.isLoggedIn = true;
      state.user = userData;
    },
    logout(state) {
      state.isLoggedIn = false;
      state.user = null;
      state.cart = [];
    },
    
    ADD_TO_CART(state, product) {
      const existingItem = state.cart.find(item => item.id === product.id);
      
      if (existingItem) {
        existingItem.quantity += 1;
      } else {
        state.cart.push({ ...product, quantity: 1 });
      }
    },
    
    REMOVE_FROM_CART(state, productId) {
      state.cart = state.cart.filter(item => item.id !== productId);
    },
    
    UPDATE_CART_QUANTITY(state, { productId, quantity }) {
      const item = state.cart.find(item => item.id === productId);
      if (item) {
        item.quantity = quantity;
        if (item.quantity <= 0) {
          state.cart = state.cart.filter(i => i.id !== productId);
        }
      }
    },
    
    CLEAR_CART(state) {
      state.cart = [];
    },
    
    SET_NOTIFICATION(state, notification) {
      state.notification = notification;
    },
    
    CLEAR_NOTIFICATION(state) {
      state.notification = null;
    },
  },
  
  actions: {
    addToCart({ commit, getters }, product) {
      const existingItem = getters.getCartItem(product.id);
      const newQuantity = existingItem ? existingItem.quantity + 1 : 1;
      
      if (newQuantity > product.stock) {
        commit('SET_NOTIFICATION', {
          type: 'error',
          message: `Stock insuficiente. Solo quedan ${product.stock} unidades.`,
        });
        return false;
      }
      
      commit('ADD_TO_CART', product);
      commit('SET_NOTIFICATION', {
        type: 'success',
        message: `${product.name} agregado al carrito`,
      });
      
      setTimeout(() => commit('CLEAR_NOTIFICATION'), 3000);
      return true;
    },
    
    removeFromCart({ commit }, productId) {
      commit('REMOVE_FROM_CART', productId);
      commit('SET_NOTIFICATION', {
        type: 'info',
        message: 'Producto eliminado del carrito',
      });
      setTimeout(() => commit('CLEAR_NOTIFICATION'), 3000);
    },
    
    updateQuantity({ commit, state }, { productId, quantity, stock }) {
      if (quantity > stock) {
        commit('SET_NOTIFICATION', {
          type: 'error',
          message: `Stock insuficiente. Solo quedan ${stock} unidades.`,
        });
        return false;
      }
      
      commit('UPDATE_CART_QUANTITY', { productId, quantity });
      return true;
    },
    
    clearCart({ commit }) {
      commit('CLEAR_CART');
      commit('SET_NOTIFICATION', {
        type: 'info',
        message: 'Carrito vaciado',
      });
      setTimeout(() => commit('CLEAR_NOTIFICATION'), 3000);
    },
  },
  
  plugins: [localStoragePlugin],
});
