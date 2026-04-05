<template>
  <div class="modern-product-list">
    <!-- Auth Overlay -->
    <div v-if="!isLoggedIn" class="auth-overlay">
      <div class="auth-container">
        <AuthForm />
      </div>
    </div>

    <!-- Main Content -->
    <div v-else class="main-layout">
      <!-- Filters Sidebar -->
      <aside class="filters-sidebar" :class="{ 'sidebar-open': filtersOpen }">
        <div class="sidebar-header">
          <h3>Filtros</h3>
          <button class="close-sidebar" @click="filtersOpen = false">✕</button>
        </div>

        <!-- Search -->
        <div class="filter-section">
          <label class="filter-label">🔍 Buscar</label>
          <BaseInput
            v-model="localSearchQuery"
            placeholder="Buscar productos..."
            clearable
            size="sm"
          />
        </div>

        <!-- Categories -->
        <div class="filter-section">
          <label class="filter-label">📂 Categorías</label>
          <div class="category-list">
            <button
              v-for="category in categories"
              :key="category.id"
              :class="['category-item', { active: selectedCategory === category.name }]"
              @click="selectCategory(category.name)"
            >
              <span class="category-icon">{{ category.icon }}</span>
              <span class="category-name">{{ category.name }}</span>
              <BaseBadge size="sm" variant="default" outlined>{{ category.count }}</BaseBadge>
            </button>
            
            <button
              :class="['category-item', { active: selectedCategory === null }]"
              @click="selectCategory(null)"
            >
              <span class="category-icon">🌟</span>
              <span class="category-name">Todos</span>
              <BaseBadge size="sm" variant="primary">{{ productList.length }}</BaseBadge>
            </button>
          </div>
        </div>

        <!-- Price Range -->
        <div class="filter-section">
          <label class="filter-label">💰 Rango de Precio</label>
          <div class="price-range">
            <BaseInput
              v-model.number="priceMin"
              type="number"
              placeholder="Min"
              size="sm"
            />
            <span class="price-separator">-</span>
            <BaseInput
              v-model.number="priceMax"
              type="number"
              placeholder="Max"
              size="sm"
            />
          </div>
        </div>

        <!-- Stock Filter -->
        <div class="filter-section">
          <label class="filter-label">📦 Disponibilidad</label>
          <label class="checkbox-label">
            <input type="checkbox" v-model="showOnlyInStock" />
            <span>Solo en stock</span>
          </label>
          <label class="checkbox-label">
            <input type="checkbox" v-model="showOutOfStock" />
            <span>Incluir agotados</span>
          </label>
        </div>

        <!-- Clear Filters -->
        <BaseButton variant="ghost" size="sm" full-width @click="clearFilters">
          🔄 Limpiar Filtros
        </BaseButton>
      </aside>

      <!-- Products Section -->
      <section class="products-section">
        <!-- Top Bar -->
        <div class="products-header">
          <div class="header-left">
            <button class="mobile-filter-btn" @click="filtersOpen = !filtersOpen">
              <span class="filter-icon">⚙️</span>
              Filtros
            </button>
            <h2 class="section-title">
              {{ selectedCategory || 'Todos los Productos' }}
            </h2>
            <BaseBadge variant="primary" size="md">
              {{ filteredProducts.length }} productos
            </BaseBadge>
          </div>

          <div class="header-right">
            <!-- Sort -->
            <select v-model="sortBy" class="sort-select">
              <option value="default">Ordenar por</option>
              <option value="price-asc">Precio: Menor a Mayor</option>
              <option value="price-desc">Precio: Mayor a Menor</option>
              <option value="name-asc">Nombre: A-Z</option>
              <option value="name-desc">Nombre: Z-A</option>
              <option value="stock-desc">Mayor stock</option>
            </select>

            <!-- View Toggle -->
            <div class="view-toggle">
              <button
                :class="['view-btn', { active: viewMode === 'grid' }]"
                @click="viewMode = 'grid'"
                title="Vista de cuadrícula"
              >
                ▦
              </button>
              <button
                :class="['view-btn', { active: viewMode === 'list' }]"
                @click="viewMode = 'list'"
                title="Vista de lista"
              >
                ☰
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-if="filteredProducts.length === 0" class="empty-state">
          <div class="empty-icon">📭</div>
          <h3>No se encontraron productos</h3>
          <p>Intenta ajustar los filtros o buscar algo diferente</p>
          <BaseButton variant="primary" @click="clearFilters">
            Ver todos los productos
          </BaseButton>
        </div>

        <!-- Products Grid -->
        <div v-else :class="['products-grid', `grid-${viewMode}`]">
          <ProductCard
            v-for="product in sortedProducts"
            :key="product.id"
            :product="product"
            @buyNow="handleBuyNow"
            @quickView="handleQuickView"
            class="animate-fade-in-up"
          />
        </div>

        <!-- Load More (Pagination simulada) -->
        <div v-if="hasMoreProducts" class="load-more-section">
          <BaseButton variant="outline" size="lg" @click="loadMore" :loading="loadingMore">
            Cargar más productos
          </BaseButton>
        </div>
      </section>

      <!-- Cart Sidebar -->
      <Cart
        :visible="cartVisible"
        @close="cartVisible = false"
        @checkout="handleCheckout"
      />

      <!-- Buy Now Modal -->
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
              <p class="stock-info">Stock: {{ selectedProduct.stock }}</p>
            </div>
          </div>
          
          <BaseInput
            v-model.number="buyNowQuantity"
            type="number"
            label="Cantidad"
            :min="1"
            :max="selectedProduct.stock"
            @input="validateQuantity"
          />
          
          <div class="buy-now-total">
            <strong>Total: ${{ (selectedProduct.price * buyNowQuantity).toFixed(2) }}</strong>
          </div>
        </div>
      </Modal>

      <!-- Quick View Modal -->
      <Modal
        :visible="showQuickView"
        title="Vista Rápida"
        type="info"
        :confirmText="null"
        @close="showQuickView = false"
      >
        <div v-if="quickViewProduct" class="quick-view-content">
          <img :src="quickViewProduct.imageUrl" :alt="quickViewProduct.name" class="quick-view-image" />
          <div class="quick-view-details">
            <h3>{{ quickViewProduct.name }}</h3>
            <BaseBadge variant="primary">{{ quickViewProduct.category }}</BaseBadge>
            <p class="quick-view-description">{{ quickViewProduct.description }}</p>
            <div class="quick-view-price">${{ quickViewProduct.price }}</div>
            <div class="quick-view-stock">
              Stock: {{ quickViewProduct.stock }} unidades
            </div>
            <div class="quick-view-actions">
              <BaseButton variant="primary" size="lg" full-width @click="addToCartFromQuickView">
                🛒 Agregar al carrito
              </BaseButton>
            </div>
          </div>
        </div>
      </Modal>

      <!-- Footer -->
      <Footer />
    </div>
  </div>
</template>

<script>
import Footer from "./Footer.vue";
import AuthForm from "./AuthForm.vue";
import ProductCard from "./ProductCard.vue";
import Cart from "./Cart_new.vue";
import Modal from "./Modal.vue";
import BaseButton from "./BaseButton.vue";
import BaseInput from "./BaseInput.vue";
import BaseBadge from "./BaseBadge.vue";

export default {
  name: 'ModernProductList',
  components: {
    Footer,
    AuthForm,
    ProductCard,
    Cart,
    Modal,
    BaseButton,
    BaseInput,
    BaseBadge
  },
  props: {
    searchQuery: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      // UI State
      filtersOpen: false,
      cartVisible: false,
      viewMode: 'grid', // 'grid' or 'list'
      loadingMore: false,
      
      // Filters
      localSearchQuery: this.searchQuery || '',
      selectedCategory: null,
      priceMin: null,
      priceMax: null,
      showOnlyInStock: false,
      showOutOfStock: true,
      sortBy: 'default',
      
      // Modals
      showBuyNowModal: false,
      showQuickView: false,
      selectedProduct: null,
      quickViewProduct: null,
      buyNowQuantity: 1,
      
      // Pagination
      displayedCount: 12,
      hasMoreProducts: false,
      
      // Products Data
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
          name: "Omega-3",
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
          description: "Ayuda a mejorar el rendimiento físico en ejercicios de alta intensidad.",
          imageUrl: "/creatine.png",
          price: 36.99,
          category: "Suplementos Alimenticios",
          stock: 12,
        },
        {
          id: 15,
          name: "Fibra Dietética",
          description: "Ayuda a la digestión y promueve la salud intestinal.",
          imageUrl: "/fiber.png",
          price: 38.99,
          category: "Suplementos Alimenticios",
          stock: 22,
        },
      ],
    };
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn;
    },
    cartItemCount() {
      return this.$store.getters.cartItemCount;
    },
    categories() {
      const cats = {};
      this.productList.forEach(product => {
        if (!cats[product.category]) {
          cats[product.category] = {
            id: product.category.toLowerCase().replace(/\s/g, '-'),
            name: product.category,
            count: 0,
            icon: this.getCategoryIcon(product.category)
          };
        }
        cats[product.category].count++;
      });
      return Object.values(cats);
    },
    filteredProducts() {
      let products = [...this.productList];
      
      // Search filter
      if (this.localSearchQuery) {
        const query = this.localSearchQuery.toLowerCase();
        products = products.filter(p =>
          p.name.toLowerCase().includes(query) ||
          p.description.toLowerCase().includes(query) ||
          p.category.toLowerCase().includes(query)
        );
      }
      
      // Category filter
      if (this.selectedCategory) {
        products = products.filter(p => p.category === this.selectedCategory);
      }
      
      // Price range filter
      if (this.priceMin !== null && this.priceMin !== '') {
        products = products.filter(p => p.price >= this.priceMin);
      }
      if (this.priceMax !== null && this.priceMax !== '') {
        products = products.filter(p => p.price <= this.priceMax);
      }
      
      // Stock filters
      if (this.showOnlyInStock) {
        products = products.filter(p => p.stock > 0);
      }
      if (!this.showOutOfStock) {
        products = products.filter(p => p.stock > 0);
      }
      
      return products;
    },
    sortedProducts() {
      let products = [...this.filteredProducts];
      
      switch (this.sortBy) {
        case 'price-asc':
          products.sort((a, b) => a.price - b.price);
          break;
        case 'price-desc':
          products.sort((a, b) => b.price - a.price);
          break;
        case 'name-asc':
          products.sort((a, b) => a.name.localeCompare(b.name));
          break;
        case 'name-desc':
          products.sort((a, b) => b.name.localeCompare(a.name));
          break;
        case 'stock-desc':
          products.sort((a, b) => b.stock - a.stock);
          break;
      }
      
      // Simulate pagination
      return products.slice(0, this.displayedCount);
    }
  },
  watch: {
    filteredProducts(newVal) {
      this.hasMoreProducts = newVal.length > this.displayedCount;
    },
    searchQuery(newVal) {
      this.localSearchQuery = newVal;
    }
  },
  methods: {
    getCategoryIcon(category) {
      const icons = {
        'Vitaminas': '💊',
        'Minerales': '⚡',
        'Suplementos Alimenticios': '🥤'
      };
      return icons[category] || '📦';
    },
    selectCategory(category) {
      this.selectedCategory = category;
      this.displayedCount = 12; // Reset pagination
    },
    clearFilters() {
      this.localSearchQuery = '';
      this.selectedCategory = null;
      this.priceMin = null;
      this.priceMax = null;
      this.showOnlyInStock = false;
      this.showOutOfStock = true;
      this.sortBy = 'default';
      this.displayedCount = 12;
    },
    loadMore() {
      this.loadingMore = true;
      setTimeout(() => {
        this.displayedCount += 12;
        this.loadingMore = false;
      }, 500);
    },
    handleBuyNow(product) {
      this.selectedProduct = product;
      this.buyNowQuantity = 1;
      this.showBuyNowModal = true;
    },
    handleQuickView(product) {
      this.quickViewProduct = product;
      this.showQuickView = true;
    },
    async addToCartFromQuickView() {
      if (this.quickViewProduct) {
        await this.$store.dispatch('addToCart', this.quickViewProduct);
        this.showQuickView = false;
      }
    },
    validateQuantity() {
      if (this.buyNowQuantity < 1) {
        this.buyNowQuantity = 1;
      }
      if (this.selectedProduct && this.buyNowQuantity > this.selectedProduct.stock) {
        this.buyNowQuantity = this.selectedProduct.stock;
      }
    },
    confirmBuyNow() {
      if (!this.selectedProduct || this.buyNowQuantity < 1) return;
      
      // Reducir stock
      this.selectedProduct.stock -= this.buyNowQuantity;
      
      // Agregar al carrito
      for (let i = 0; i < this.buyNowQuantity; i++) {
        this.$store.dispatch('addToCart', this.selectedProduct);
      }
      
      this.$store.commit('setNotification', {
        type: 'success',
        message: `Compra confirmada: ${this.buyNowQuantity}x ${this.selectedProduct.name}`,
        duration: 3000
      });
      
      this.showBuyNowModal = false;
      this.selectedProduct = null;
    },
    cancelBuyNow() {
      this.showBuyNowModal = false;
      this.selectedProduct = null;
      this.buyNowQuantity = 1;
    },
    toggleCartVisibility() {
      this.cartVisible = !this.cartVisible;
    },
    handleCheckout() {
      const totalItems = this.$store.getters.cartItemCount;
      const totalPrice = this.$store.getters.cartTotal;
      
      this.$store.commit('setNotification', {
        type: 'success',
        message: `Compra realizada: ${totalItems} items por $${totalPrice.toFixed(2)}`,
        duration: 5000
      });
      
      this.$store.dispatch('clearCart');
      this.cartVisible = false;
    }
  }
};
</script>

<style scoped>
/* ===== Main Layout ===== */
.modern-product-list {
  min-height: 100vh;
  background: var(--bg-primary);
}

.main-layout {
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: var(--space-6);
  max-width: 1600px;
  margin: 0 auto;
  padding: var(--space-6);
}

/* ===== Auth Overlay ===== */
.auth-overlay {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-6);
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
}

.auth-container {
  max-width: 450px;
  width: 100%;
}

/* ===== Filters Sidebar ===== */
.filters-sidebar {
  position: sticky;
  top: var(--space-6);
  height: fit-content;
  background: var(--surface);
  border-radius: var(--radius-xl);
  padding: var(--space-6);
  box-shadow: var(--shadow-md);
  border: 1px solid var(--border-color);
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.sidebar-header h3 {
  font-size: var(--text-xl);
  font-weight: var(--font-bold);
  color: var(--text-primary);
  margin: 0;
}

.close-sidebar {
  display: none;
  background: none;
  border: none;
  font-size: var(--text-2xl);
  cursor: pointer;
  color: var(--text-secondary);
  padding: var(--space-2);
  line-height: 1;
}

.filter-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.filter-label {
  font-size: var(--text-sm);
  font-weight: var(--font-semibold);
  color: var(--text-primary);
}

.category-list {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.category-item {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3);
  background: transparent;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all var(--transition-fast);
  text-align: left;
  color: var(--text-primary);
  font-size: var(--text-sm);
}

.category-item:hover {
  background: var(--surface-hover);
  border-color: var(--color-primary);
}

.category-item.active {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.category-icon {
  font-size: var(--text-xl);
}

.category-name {
  flex: 1;
  font-weight: var(--font-medium);
}

.price-range {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.price-separator {
  color: var(--text-secondary);
}

.checkbox-label {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  cursor: pointer;
  font-size: var(--text-sm);
  color: var(--text-primary);
}

.checkbox-label input[type="checkbox"] {
  width: 18px;
  height: 18px;
  cursor: pointer;
  accent-color: var(--color-primary);
}

/* ===== Products Section ===== */
.products-section {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.products-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: var(--space-4);
  padding: var(--space-4);
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
}

.header-left {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  flex: 1;
}

.mobile-filter-btn {
  display: none;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-4);
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  cursor: pointer;
  font-weight: var(--font-medium);
  transition: all var(--transition-fast);
}

.mobile-filter-btn:hover {
  background: var(--color-primary-dark);
}

.section-title {
  font-size: var(--text-2xl);
  font-weight: var(--font-bold);
  color: var(--text-primary);
  margin: 0;
}

.header-right {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.sort-select {
  padding: var(--space-2) var(--space-4);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  background: var(--surface);
  color: var(--text-primary);
  font-size: var(--text-sm);
  cursor: pointer;
  transition: all var(--transition-fast);
}

.sort-select:focus {
  outline: none;
  border-color: var(--color-primary);
}

.view-toggle {
  display: flex;
  gap: 0;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  overflow: hidden;
}

.view-btn {
  padding: var(--space-2) var(--space-4);
  background: var(--surface);
  border: none;
  color: var(--text-secondary);
  font-size: var(--text-xl);
  cursor: pointer;
  transition: all var(--transition-fast);
  border-right: 1px solid var(--border-color);
}

.view-btn:last-child {
  border-right: none;
}

.view-btn.active {
  background: var(--color-primary);
  color: white;
}

.view-btn:hover:not(.active) {
  background: var(--surface-hover);
}

/* ===== Products Grid ===== */
.products-grid {
  display: grid;
  gap: var(--space-6);
}

.grid-grid {
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
}

.grid-list {
  grid-template-columns: 1fr;
  gap: var(--space-4);
}

/* ===== Empty State ===== */
.empty-state {
  text-align: center;
  padding: var(--space-16) var(--space-6);
  background: var(--surface);
  border-radius: var(--radius-xl);
  box-shadow: var(--shadow-sm);
}

.empty-icon {
  font-size: 5rem;
  margin-bottom: var(--space-6);
}

.empty-state h3 {
  font-size: var(--text-2xl);
  color: var(--text-primary);
  margin-bottom: var(--space-2);
}

.empty-state p {
  color: var(--text-secondary);
  margin-bottom: var(--space-6);
}

/* ===== Load More ===== */
.load-more-section {
  display: flex;
  justify-content: center;
  padding: var(--space-6);
}

/* ===== Buy Now Modal Content ===== */
.buy-now-content {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.buy-now-product {
  display: flex;
  gap: var(--space-4);
  align-items: center;
  padding: var(--space-4);
  background: var(--bg-secondary);
  border-radius: var(--radius-md);
}

.buy-now-product img {
  width: 80px;
  height: 80px;
  object-fit: contain;
}

.buy-now-product h4 {
  margin: 0;
  color: var(--text-primary);
}

.product-price {
  font-size: var(--text-xl);
  font-weight: var(--font-bold);
  color: var(--color-primary);
  margin: var(--space-1) 0;
}

.stock-info {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  margin: 0;
}

.buy-now-total {
  padding: var(--space-4);
  background: var(--bg-secondary);
  border-radius: var(--radius-md);
  text-align: center;
  font-size: var(--text-xl);
  color: var(--text-primary);
}

/* ===== Quick View Modal Content ===== */
.quick-view-content {
  display: flex;
  flex-direction: column;
  gap: var(--space-6);
}

.quick-view-image {
  width: 100%;
  max-height: 300px;
  object-fit: contain;
  background: var(--bg-secondary);
  border-radius: var(--radius-lg);
  padding: var(--space-6);
}

.quick-view-details {
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
}

.quick-view-details h3 {
  font-size: var(--text-2xl);
  color: var(--text-primary);
  margin: 0;
}

.quick-view-description {
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
}

.quick-view-price {
  font-size: var(--text-3xl);
  font-weight: var(--font-bold);
  color: var(--color-primary);
}

.quick-view-stock {
  font-size: var(--text-sm);
  color: var(--text-secondary);
}

.quick-view-actions {
  margin-top: var(--space-4);
}

/* ===== Responsive ===== */
@media (max-width: 1024px) {
  .main-layout {
    grid-template-columns: 1fr;
  }
  
  .filters-sidebar {
    position: fixed;
    top: 0;
    left: -100%;
    width: 320px;
    max-width: 85vw;
    height: 100vh;
    z-index: var(--z-modal);
    transition: left var(--transition-base);
    overflow-y: auto;
  }
  
  .filters-sidebar.sidebar-open {
    left: 0;
  }
  
  .close-sidebar {
    display: block;
  }
  
  .mobile-filter-btn {
    display: flex;
  }
  
  .products-grid.grid-grid {
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  }
}

@media (max-width: 768px) {
  .main-layout {
    padding: var(--space-4);
    gap: var(--space-4);
  }
  
  .products-header {
    flex-direction: column;
    align-items: stretch;
  }
  
  .header-left {
    flex-direction: column;
    align-items: stretch;
  }
  
  .section-title {
    font-size: var(--text-xl);
  }
  
  .header-right {
    flex-direction: column;
  }
  
  .sort-select,
  .view-toggle {
    width: 100%;
  }
  
  .products-grid.grid-grid {
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: var(--space-4);
  }
}

@media (max-width: 640px) {
  .main-layout {
    padding: var(--space-3);
  }
  
  .products-grid.grid-grid {
    grid-template-columns: 1fr;
  }
}
</style>
