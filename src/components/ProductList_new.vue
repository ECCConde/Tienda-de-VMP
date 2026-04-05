<template>
  <div class="product-list-container">
    <div v-if="!isLoggedIn" class="auth-overlay">
      <AuthForm />
    </div>
    
    <div v-else class="main-content">
      <div class="top-bar">
        <h1 class="page-title">Nuestra Tienda</h1>
        <div class="top-actions">
          <button @click="toggleCartVisibility" class="cart-button">
            <img src="../assets/cart-icon.png" alt="Carrito" width="25" height="25" />
            <span v-if="cartItemCount > 0" class="cart-badge">{{ cartItemCount }}</span>
            <span class="cart-text">Carrito</span>
          </button>
        </div>
      </div>

      <div class="layout-container">
        <aside class="categories-sidebar">
          <h3>Categorías</h3>
          <ul>
            <li 
              :class="{ active: selectedCategory === null }"
              @click="navigateToCategory(null)"
            >
              Todos los Productos
            </li>
            <li
              v-for="category in categories"
              :key="category.id"
              :class="{ active: selectedCategory === category.name }"
              @click="navigateToCategory(category.name)"
            >
              {{ category.name }}
            </li>
          </ul>
        </aside>

        <section class="product-section">
          <div class="section-header">
            <h2>{{ selectedCategory || 'Todos los Productos' }}</h2>
            <p class="product-count">{{ filteredProducts.length }} productos disponibles</p>
          </div>

          <div class="product-grid">
            <Product
              v-for="product in filteredProducts"
              :key="product.id"
              :product="product"
              @buyNow="buyNow"
            />
          </div>
        </section>
      </div>

      <Cart
        :visible="cartVisible"
        @close="cartVisible = false"
        @checkout="checkout"
      />

      <Modal
        :visible="showBuyNowModal"
        title="Compra Directa"
        type="primary"
        confirmText="Confirmar Compra"
        @confirm="confirmBuyNow"
        @close="cancelBuyNow"
      >
        <div v-if="selectedProduct" class="buy-now-content">
          <div class="buy-now-product">
            <img :src="selectedProduct.imageUrl" :alt="selectedProduct.name" />
            <div>
              <h4>{{ selectedProduct.name }}</h4>
              <p class="product-price">${{ selectedProduct.price }}</p>
              <p class="stock-info">Stock disponible: {{ selectedProduct.stock }}</p>
            </div>
          </div>
          
          <div class="quantity-input">
            <label>Cantidad:</label>
            <input 
              type="number" 
              v-model.number="buyNowQuantity" 
              min="1" 
              :max="selectedProduct.stock"
              @input="validateQuantity"
            />
          </div>
          
          <div class="buy-now-total">
            <strong>Total: ${{ (selectedProduct.price * buyNowQuantity).toFixed(2) }}</strong>
          </div>
        </div>
      </Modal>

      <Footer />
    </div>
  </div>
</template>

<script>
import Footer from "./Footer.vue";
import AuthForm from "./AuthForm.vue";
import Product from "./Product_new.vue";
import Cart from "./Cart_new.vue";
import Modal from "./Modal.vue";

export default {
  components: {
    Footer,
    AuthForm,
    Product,
    Cart,
    Modal,
  },
  data() {
    return {
      productList: [
        {
          id: 1,
          name: "Vitamina D",
          description: "Importante para la salud ósea y el sistema inmunológico.",
          imageUrl: "/vitamin_d.png",
          price: 10.99,
          category: "Vitaminas",
          stock: 50,
        },
        {
          id: 2,
          name: "Vitamina C",
          description: "Antioxidante, ayuda en la recuperación y apoya al sistema inmunológico.",
          imageUrl: "/vitamin_c.png",
          price: 12.99,
          category: "Vitaminas",
          stock: 30,
        },
        {
          id: 3,
          name: "Vitamina B12",
          description: "Esencial para la formación de glóbulos rojos y el funcionamiento del sistema nervioso.",
          imageUrl: "/vitamin_b12.png",
          price: 14.99,
          category: "Vitaminas",
          stock: 20,
        },
        {
          id: 4,
          name: "Vitamina A",
          description: "Importante para la visión, el sistema inmunológico y la salud de la piel.",
          imageUrl: "/vitamin_a.png",
          price: 16.99,
          category: "Vitaminas",
          stock: 25,
        },
        {
          id: 5,
          name: "Vitamina E",
          description: "Propiedades antioxidantes y ayuda a mantener la piel sana.",
          imageUrl: "/vitamin_e.png",
          price: 18.99,
          category: "Vitaminas",
          stock: 15,
        },
        {
          id: 6,
          name: "Calcio",
          description: "Esencial para la salud ósea y dental.",
          imageUrl: "/calcium.png",
          price: 20.99,
          category: "Minerales",
          stock: 40,
        },
        {
          id: 7,
          name: "Hierro",
          description: "Importante para la formación de hemoglobina y el transporte de oxígeno en la sangre.",
          imageUrl: "/iron.png",
          price: 22.99,
          category: "Minerales",
          stock: 35,
        },
        {
          id: 8,
          name: "Magnesio",
          description: "Contribuye al funcionamiento muscular y nervioso, así como a la formación ósea.",
          imageUrl: "/magnesium.png",
          price: 24.99,
          category: "Minerales",
          stock: 30,
        },
        {
          id: 9,
          name: "Zinc",
          description: "Participa en el sistema inmunológico y contribuye a la salud de la piel.",
          imageUrl: "/zinc.png",
          price: 26.99,
          category: "Minerales",
          stock: 25,
        },
        {
          id: 10,
          name: "Yodo",
          description: "Necesario para la función tiroidea y el desarrollo adecuado.",
          imageUrl: "/iodine.png",
          price: 28.99,
          category: "Minerales",
          stock: 20,
        },
        {
          id: 11,
          name: "Proteína en polvo",
          description: "Ayuda en la reparación y construcción muscular.",
          imageUrl: "/protein_powder.png",
          price: 30.99,
          category: "Suplementos Alimenticios",
          stock: 15,
        },
        {
          id: 12,
          name: "Omega-3 (ácidos grasos esenciales)",
          description: "Beneficioso para la salud cardiovascular y el funcionamiento cerebral.",
          imageUrl: "/omega_3.png",
          price: 32.99,
          category: "Suplementos Alimenticios",
          stock: 10,
        },
        {
          id: 13,
          name: "Glutamina",
          description: "Importante para la recuperación muscular y el sistema inmunológico.",
          imageUrl: "/glutamine.png",
          price: 34.99,
          category: "Suplementos Alimenticios",
          stock: 18,
        },
        {
          id: 14,
          name: "Creatina",
          description: "Contribuye a la mejora del rendimiento atlético y la fuerza muscular.",
          imageUrl: "/creatine.png",
          price: 36.99,
          category: "Suplementos Alimenticios",
          stock: 12,
        },
        {
          id: 15,
          name: "Fibra alimentaria",
          description: "Promueve la salud digestiva y ayuda en el control del peso.",
          imageUrl: "/fiber.png",
          price: 38.99,
          category: "Suplementos Alimenticios",
          stock: 25,
        },
      ],
      cartVisible: false,
      selectedCategory: null,
      showBuyNowModal: false,
      selectedProduct: null,
      buyNowQuantity: 1,
    };
  },
  computed: {
    categories() {
      const uniqueCategories = new Set(
        this.productList.map((product) => product.category)
      );
      return Array.from(uniqueCategories).map((category) => ({
        id: category,
        name: category,
      }));
    },
    filteredProducts() {
      return this.selectedCategory
        ? this.productList.filter(
            (product) => product.category === this.selectedCategory
          )
        : this.productList;
    },
    isLoggedIn() {
      return this.$store.state.isLoggedIn;
    },
    user() {
      return this.$store.state.user;
    },
    cartItemCount() {
      return this.$store.getters.cartItemCount;
    },
  },
  methods: {
    toggleCartVisibility() {
      this.cartVisible = !this.cartVisible;
    },
    
    navigateToCategory(categoryName) {
      this.selectedCategory = categoryName;
    },
    
    buyNow(product) {
      this.selectedProduct = product;
      this.buyNowQuantity = 1;
      this.showBuyNowModal = true;
    },
    
    validateQuantity() {
      if (this.buyNowQuantity < 1) {
        this.buyNowQuantity = 1;
      }
      if (this.buyNowQuantity > this.selectedProduct.stock) {
        this.buyNowQuantity = this.selectedProduct.stock;
        this.$store.commit('SET_NOTIFICATION', {
          type: 'warning',
          message: `Solo quedan ${this.selectedProduct.stock} unidades disponibles`,
        });
        setTimeout(() => this.$store.commit('CLEAR_NOTIFICATION'), 3000);
      }
    },
    
    confirmBuyNow() {
      if (this.buyNowQuantity > this.selectedProduct.stock) {
        this.$store.commit('SET_NOTIFICATION', {
          type: 'error',
          message: 'Stock insuficiente',
        });
        setTimeout(() => this.$store.commit('CLEAR_NOTIFICATION'), 3000);
        return;
      }
      
      // Reducir stock
      const product = this.productList.find(p => p.id === this.selectedProduct.id);
      if (product) {
        product.stock -= this.buyNowQuantity;
      }
      
      this.$store.commit('SET_NOTIFICATION', {
        type: 'success',
        message: `Compra realizada con éxito. Total: $${(this.selectedProduct.price * this.buyNowQuantity).toFixed(2)}`,
      });
      setTimeout(() => this.$store.commit('CLEAR_NOTIFICATION'), 3000);
      
      this.showBuyNowModal = false;
      this.selectedProduct = null;
    },
    
    cancelBuyNow() {
      this.showBuyNowModal = false;
      this.selectedProduct = null;
    },
    
    checkout() {
      const cartItems = this.$store.state.cart;
      
      // Verificar stock
      const insufficientStock = cartItems.some(item => {
        const product = this.productList.find(p => p.id === item.id);
        return !product || item.quantity > product.stock;
      });
      
      if (insufficientStock) {
        this.$store.commit('SET_NOTIFICATION', {
          type: 'error',
          message: 'Stock insuficiente para algunos productos',
        });
        setTimeout(() => this.$store.commit('CLEAR_NOTIFICATION'), 3000);
        return;
      }
      
      // Reducir stock
      cartItems.forEach(item => {
        const product = this.productList.find(p => p.id === item.id);
        if (product) {
          product.stock -= item.quantity;
        }
      });
      
      const total = this.$store.getters.cartTotal;
      
      this.$store.commit('CLEAR_CART');
      this.$store.commit('SET_NOTIFICATION', {
        type: 'success',
        message: `¡Compra realizada con éxito! Total: $${total.toFixed(2)}`,
      });
      setTimeout(() => this.$store.commit('CLEAR_NOTIFICATION'), 4000);
      
      this.cartVisible = false;
    },
  },
};
</script>

<style scoped>
.product-list-container {
  min-height: 100vh;
}

.auth-overlay {
  min-height: 80vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
}

.main-content {
  padding-bottom: 40px;
}

.top-bar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 30px 40px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.page-title {
  margin: 0 0 10px 0;
  font-size: 2.5rem;
  font-weight: 700;
}

.top-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: -40px;
}

.cart-button {
  display: flex;
  align-items: center;
  gap: 8px;
  background: white;
  color: #667eea;
  border: none;
  padding: 12px 24px;
  border-radius: 25px;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.cart-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.cart-badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: #e74c3c;
  color: white;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
  border: 2px solid white;
}

.layout-container {
  display: flex;
  gap: 30px;
  max-width: 1400px;
  margin: 30px auto;
  padding: 0 20px;
}

.categories-sidebar {
  width: 250px;
  background: white;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  height: fit-content;
  position: sticky;
  top: 20px;
}

.categories-sidebar h3 {
  margin: 0 0 16px 0;
  color: #2c3e50;
  font-size: 1.3rem;
}

.categories-sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.categories-sidebar li {
  cursor: pointer;
  padding: 12px 16px;
  margin-bottom: 8px;
  background: #f8f9fa;
  border-radius: 8px;
  transition: all 0.2s;
  color: #555;
  font-weight: 500;
}

.categories-sidebar li:hover {
  background: #e9ecef;
  transform: translateX(4px);
}

.categories-sidebar li.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.product-section {
  flex: 1;
}

.section-header {
  margin-bottom: 24px;
}

.section-header h2 {
  margin: 0 0 8px 0;
  color: #2c3e50;
  font-size: 2rem;
}

.product-count {
  margin: 0;
  color: #7f8c8d;
  font-size: 0.95rem;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.buy-now-content {
  padding: 10px 0;
}

.buy-now-product {
  display: flex;
  gap: 16px;
  align-items: center;
  margin-bottom: 20px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
}

.buy-now-product img {
  width: 80px;
  height: 80px;
  object-fit: contain;
  border-radius: 8px;
}

.buy-now-product h4 {
  margin: 0 0 8px 0;
  color: #2c3e50;
}

.buy-now-product .product-price {
  margin: 4px 0;
  color: #27ae60;
  font-weight: bold;
  font-size: 1.2rem;
}

.buy-now-product .stock-info {
  margin: 4px 0;
  color: #7f8c8d;
  font-size: 0.9rem;
}

.quantity-input {
  margin: 20px 0;
}

.quantity-input label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: #2c3e50;
}

.quantity-input input {
  width: 100%;
  padding: 10px;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 16px;
}

.quantity-input input:focus {
  outline: none;
  border-color: #667eea;
}

.buy-now-total {
  margin-top: 20px;
  padding: 16px;
  background: #f8f9fa;
  border-radius: 8px;
  text-align: right;
  font-size: 1.3rem;
  color: #2c3e50;
}

@media (max-width: 1024px) {
  .layout-container {
    flex-direction: column;
  }
  
  .categories-sidebar {
    width: 100%;
    position: static;
  }
  
  .categories-sidebar ul {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .categories-sidebar li {
    margin-bottom: 0;
  }
}

@media (max-width: 768px) {
  .product-grid {
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 16px;
  }
  
  .page-title {
    font-size: 2rem;
  }
  
  .top-actions {
    margin-top: 16px;
  }
}
</style>
