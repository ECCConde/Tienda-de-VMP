<!-- Product.vue -->
<template>
  <div class="product-card">
    <img :src="product.imageUrl" :alt="product.name" class="product-image">

    <div class="product-details">
      <h3 class="product-name">{{ product.name }}</h3>
      <p class="product-description">{{ product.description }}</p>
      <p class="product-price">${{ product.price }}</p>
    </div>
    <div class="product-actions">
      <button @click="buyNow">Comprar Directo</button>
      <div class="quantity-selector">
        <button @click="addToCart">Agregar al Carrito</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    product: Object,
  },
  data() {
    return {
      selectedQuantity: 1,
    };
  },
  methods: {
    addToCart() {
      this.$emit('addToCart', this.selectedQuantity);
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
  border-radius: 8px;
  margin-bottom: 20px;
  overflow: hidden;
  transition: transform 0.3s ease-in-out;
  width: 100%; 
  }

.product-card:hover {
  transform: scale(1.05);
}

.product-card img {
  width: 100%;
  height: auto;
}

.product-details {
  padding: 20px;
}

.product-name {
  font-size: 1.2rem;
  margin-bottom: 10px;
}

.product-description {
  margin-bottom: 10px;
}

.product-price {
  font-size: 1.1rem;
  color: #27ae60;
}

.product-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}

.quantity-selector {
  display: flex;
  align-items: center;
}

.quantity-selector label {
  margin-right: 10px;
}

.quantity-selector input {
  width: 40px;
  margin-right: 10px;
}

button {
  display: inline-block;
  padding: 10px 20px;
  background-color: #27ae60;
  color: #fff;
  text-decoration: none;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease-in-out;
}

button:hover {
  background-color: #218c53;
}
</style>
