<template>
  <div>
    <div v-if="visible" class="cart-container">
      <div class="cart-header">
        <h2>Carrito de Compras</h2>
        <button @click="handleClose" class="close-cart-btn">&times;</button>
      </div>
      
      <div v-if="cartItems.length === 0" class="empty-cart">
        <p>El carrito está vacío</p>
      </div>
      
      <div v-else class="cart-content">
        <div v-for="item in cartItems" :key="item.id" class="cart-item">
          <div class="item-info">
            <img :src="item.imageUrl" :alt="item.name" class="item-image">
            <div class="item-details">
              <h4>{{ item.name }}</h4>
              <p class="item-price">${{ item.price }}</p>
            </div>
          </div>
          
          <div class="item-actions">
            <div class="quantity-controls">
              <button @click="decreaseQuantity(item)" class="qty-btn">-</button>
              <span class="quantity">{{ item.quantity }}</span>
              <button @click="increaseQuantity(item)" class="qty-btn">+</button>
            </div>
            <p class="item-total">${{ (item.price * item.quantity).toFixed(2) }}</p>
            <button @click="removeItem(item.id)" class="remove-btn">🗑️</button>
          </div>
        </div>
        
        <div class="cart-summary">
          <div class="summary-row">
            <span>Subtotal:</span>
            <span>${{ cartTotal.toFixed(2) }}</span>
          </div>
          <div class="summary-row total">
            <span>Total:</span>
            <span>${{ cartTotal.toFixed(2) }}</span>
          </div>
        </div>
        
        <div class="cart-footer">
          <button @click="handleClearCart" class="btn-clear">Limpiar Carrito</button>
          <button @click="handleCheckout" class="btn-checkout">Finalizar Compra</button>
        </div>
      </div>
    </div>
    
    <Modal
      :visible="showCheckoutModal"
      title="Confirmar Compra"
      :message="`¿Deseas finalizar la compra por un total de $${cartTotal.toFixed(2)}?`"
      type="success"
      confirmText="Confirmar Compra"
      @confirm="confirmCheckout"
      @close="showCheckoutModal = false"
    />
    
    <Modal
      :visible="showClearModal"
      title="Limpiar Carrito"
      message="¿Estás seguro de que deseas vaciar el carrito?"
      type="danger"
      confirmText="Sí, limpiar"
      @confirm="confirmClear"
      @close="showClearModal = false"
    />
  </div>
</template>

<script>
import Modal from './Modal.vue';

export default {
  components: {
    Modal,
  },
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {
      showCheckoutModal: false,
      showClearModal: false,
    };
  },
  computed: {
    cartItems() {
      return this.$store.state.cart;
    },
    cartTotal() {
      return this.$store.getters.cartTotal;
    },
  },
  methods: {
    handleClose() {
      this.$emit('close');
    },
    
    increaseQuantity(item) {
      const product = this.$parent.productList?.find(p => p.id === item.id);
      if (product) {
        this.$store.dispatch('updateQuantity', {
          productId: item.id,
          quantity: item.quantity + 1,
          stock: product.stock,
        });
      }
    },
    
    decreaseQuantity(item) {
      if (item.quantity > 1) {
        this.$store.commit('UPDATE_CART_QUANTITY', {
          productId: item.id,
          quantity: item.quantity - 1,
        });
      } else {
        this.removeItem(item.id);
      }
    },
    
    removeItem(productId) {
      this.$store.dispatch('removeFromCart', productId);
    },
    
    handleClearCart() {
      this.showClearModal = true;
    },
    
    confirmClear() {
      this.$store.dispatch('clearCart');
      this.showClearModal = false;
    },
    
    handleCheckout() {
      if (this.cartItems.length === 0) return;
      this.showCheckoutModal = true;
    },
    
    confirmCheckout() {
      this.$emit('checkout');
      this.showCheckoutModal = false;
    },
  },
};
</script>

<style scoped>
.cart-container {
  position: fixed;
  top: 0;
  right: 0;
  width: 420px;
  height: 100vh;
  background: white;
  box-shadow: -4px 0 20px rgba(0, 0, 0, 0.15);
  z-index: 1000;
  display: flex;
  flex-direction: column;
  animation: slideInRight 0.3s ease-out;
}

@keyframes slideInRight {
  from {
    transform: translateX(100%);
  }
  to {
    transform: translateX(0);
  }
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 2px solid #ecf0f1;
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: white;
}

.cart-header h2 {
  margin: 0;
  font-size: 20px;
}

.close-cart-btn {
  background: none;
  border: none;
  color: white;
  font-size: 32px;
  cursor: pointer;
  padding: 0;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s;
}

.close-cart-btn:hover {
  transform: scale(1.2);
}

.empty-cart {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #95a5a6;
  font-size: 16px;
}

.cart-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
}

.cart-item {
  padding: 16px;
  border-bottom: 1px solid #ecf0f1;
}

.item-info {
  display: flex;
  gap: 12px;
  margin-bottom: 12px;
}

.item-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 8px;
  border: 1px solid #ecf0f1;
}

.item-details {
  flex: 1;
}

.item-details h4 {
  margin: 0 0 4px 0;
  font-size: 14px;
  color: #2c3e50;
}

.item-price {
  margin: 0;
  color: #27ae60;
  font-weight: bold;
}

.item-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.quantity-controls {
  display: flex;
  align-items: center;
  gap: 8px;
  background: #ecf0f1;
  border-radius: 20px;
  padding: 4px 8px;
}

.qty-btn {
  background: white;
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 16px;
  font-weight: bold;
  color: #3498db;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
}

.qty-btn:hover {
  background: #3498db;
  color: white;
}

.quantity {
  min-width: 30px;
  text-align: center;
  font-weight: bold;
  color: #2c3e50;
}

.item-total {
  font-weight: bold;
  color: #2c3e50;
  margin: 0;
}

.remove-btn {
  background: #e74c3c;
  border: none;
  width: 32px;
  height: 32px;
  border-radius: 6px;
  cursor: pointer;
  font-size: 16px;
  transition: all 0.2s;
}

.remove-btn:hover {
  background: #c0392b;
  transform: scale(1.1);
}

.cart-summary {
  padding: 16px 20px;
  border-top: 2px solid #ecf0f1;
  background: #f8f9fa;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 14px;
  color: #7f8c8d;
}

.summary-row.total {
  font-size: 18px;
  font-weight: bold;
  color: #2c3e50;
  margin-top: 8px;
  padding-top: 8px;
  border-top: 1px solid #d5dbdb;
}

.cart-footer {
  padding: 16px 20px;
  display: flex;
  gap: 12px;
  border-top: 1px solid #ecf0f1;
}

.btn-clear,
.btn-checkout {
  flex: 1;
  padding: 12px;
  border: none;
  border-radius: 8px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 14px;
}

.btn-clear {
  background: #ecf0f1;
  color: #7f8c8d;
}

.btn-clear:hover {
  background: #d5dbdb;
  color: #2c3e50;
}

.btn-checkout {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  color: white;
}

.btn-checkout:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.4);
}

@media (max-width: 768px) {
  .cart-container {
    width: 100%;
  }
}
</style>
