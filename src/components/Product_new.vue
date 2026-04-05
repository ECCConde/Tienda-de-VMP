<!-- Product.vue -->
<template>
  <div class="product-card">
    <img :src="product.imageUrl" :alt="product.name" class="product-image">

    <div class="product-details">
      <h3 class="product-name">{{ product.name }}</h3>
      <p class="product-description">{{ product.description }}</p>
      <p class="product-price">${{ product.price }}</p>
      <p class="product-stock">
        <span :class="['stock-badge', stockClass]">
          {{ stockText }}
        </span>
      </p>
    </div>
    <div class="product-actions">
      <button 
        @click="buyNow" 
        class="btn-buy"
        :disabled="product.stock === 0"
      >
        Comprar Ahora
      </button>
      <button 
        @click="addToCart" 
        class="btn-cart"
        :disabled="product.stock === 0"
      >
        Agregar al Carrito
      </button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    product: Object,
  },
  computed: {
    stockClass() {
      if (this.product.stock === 0) return 'out-of-stock';
      if (this.product.stock < 10) return 'low-stock';
      return 'in-stock';
    },
    stockText() {
      if (this.product.stock === 0) return 'Agotado';
      if (this.product.stock < 10) return `Solo ${this.product.stock} disponibles`;
      return `${this.product.stock} disponibles`;
    },
  },
  methods: {
    addToCart() {
      this.$store.dispatch('addToCart', this.product);
    },
    buyNow() {
      this.$emit('buyNow', this.product);
    },
  },
};
</script>

<style scoped>
.product-image {
  max-width: 300px; 
  height: auto; 
}
.product-card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 12px;
  margin-bottom: 20px;
  overflow: hidden;
  transition: all 0.3s ease-in-out;
  width: 100%;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.product-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.product-card img {
  width: 100%;
  height: 200px;
  object-fit: contain;
  padding: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

.product-details {
  padding: 20px;
}

.product-name {
  font-size: 1.2rem;
  margin-bottom: 10px;
  color: #2c3e50;
}

.product-description {
  margin-bottom: 12px;
  color: #7f8c8d;
  font-size: 0.9rem;
  line-height: 1.5;
}

.product-price {
  font-size: 1.4rem;
  color: #27ae60;
  font-weight: bold;
  margin-bottom: 8px;
}

.product-stock {
  margin: 8px 0;
}

.stock-badge {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 0.85rem;
  font-weight: 500;
}

.in-stock {
  background: #d4edda;
  color: #155724;
}

.low-stock {
  background: #fff3cd;
  color: #856404;
}

.out-of-stock {
  background: #f8d7da;
  color: #721c24;
}

.product-actions {
  display: flex;
  gap: 10px;
  padding: 0 20px 20px;
}

.btn-buy,
.btn-cart {
  flex: 1;
  padding: 12px 20px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease-in-out;
  font-weight: 600;
  font-size: 14px;
}

.btn-buy {
  background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
  color: #fff;
}

.btn-buy:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
}

.btn-cart {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
  color: #fff;
}

.btn-cart:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(39, 174, 96, 0.4);
}

.btn-buy:disabled,
.btn-cart:disabled {
  background: #95a5a6;
  cursor: not-allowed;
  opacity: 0.6;
}
</style>
