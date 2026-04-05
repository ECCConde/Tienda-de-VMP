<template>
  <div class="product-card" :class="{ 'out-of-stock': isOutOfStock }">
    <!-- Card Inner (for 3D effect) -->
    <div class="card-inner">
      <!-- Badges -->
      <div class="product-badges">
        <BaseBadge v-if="isNew" variant="accent" size="sm" rounded>
          ✨ Nuevo
        </BaseBadge>
        <BaseBadge v-if="isOnSale" variant="error" size="sm" rounded>
          🔥 Oferta
        </BaseBadge>
        <BaseBadge v-if="isOutOfStock" variant="default" size="sm" rounded>
          ❌ Agotado
        </BaseBadge>
        <BaseBadge v-else-if="isLowStock" variant="warning" size="sm" rounded>
          ⚠️ Pocas unidades
        </BaseBadge>
      </div>

      <!-- Favorite Button -->
      <button 
        class="favorite-btn"
        :class="{ active: isFavorite }"
        @click.stop="toggleFavorite"
        aria-label="Agregar a favoritos"
      >
        {{ isFavorite ? '❤️' : '🤍' }}
      </button>

      <!-- Image Container -->
      <div class="product-image-container" @click="handleQuickView">
        <img 
          :src="product.imageUrl" 
          :alt="product.name"
          class="product-image"
          loading="lazy"
        />
        <div class="image-overlay">
          <button class="quick-view-btn" @click.stop="handleQuickView">
            👁️ Vista Rápida
          </button>
        </div>
      </div>

      <!-- Card Body -->
      <div class="card-body">
        <!-- Category -->
        <BaseBadge variant="primary" size="sm" outlined class="category-badge">
          {{ product.category }}
        </BaseBadge>

        <!-- Product Name -->
        <h3 class="product-name">{{ product.name }}</h3>

        <!-- Description -->
        <p class="product-description">{{ truncatedDescription }}</p>

        <!-- Rating (Simulado) -->
        <div class="product-rating">
          <span class="stars">⭐⭐⭐⭐⭐</span>
          <span class="rating-count">({{ randomReviews }})</span>
        </div>

        <!-- Price & Stock Info -->
        <div class="product-footer">
          <div class="price-container">
            <span v-if="isOnSale" class="price-old">${{ (product.price * 1.2).toFixed(2) }}</span>
            <span class="price-current">${{ product.price }}</span>
          </div>
          
          <div class="stock-indicator">
            <span class="stock-dot" :class="stockStatusClass"></span>
            <span class="stock-text">{{ stockText }}</span>
          </div>
        </div>

        <!-- Actions -->
        <div class="card-actions">
          <BaseButton
            variant="primary"
            size="md"
            :disabled="isOutOfStock"
            :loading="loading"
            @click="handleAddToCart"
            full-width
          >
            <template #iconLeft>🛒</template>
            {{ isOutOfStock ? 'Agotado' : 'Agregar' }}
          </BaseButton>
          
          <BaseButton
            variant="outline"
            size="md"
            :disabled="isOutOfStock"
            @click="handleBuyNow"
            full-width
          >
            <template #iconLeft>⚡</template>
            Comprar
          </BaseButton>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import BaseButton from './BaseButton.vue';
import BaseBadge from './BaseBadge.vue';

export default {
  name: 'ProductCard',
  components: {
    BaseButton,
    BaseBadge
  },
  props: {
    product: {
      type: Object,
      required: true
    }
  },
  emits: ['buyNow', 'quickView', 'toggleFavorite'],
  data() {
    return {
      loading: false,
      isFavorite: false,
      randomReviews: Math.floor(Math.random() * 200) + 10
    };
  },
  computed: {
    isOutOfStock() {
      return this.product.stock === 0;
    },
    isLowStock() {
      return this.product.stock > 0 && this.product.stock <= 5;
    },
    isNew() {
      // Productos con ID > 10 son "nuevos" (ejemplo)
      return this.product.id > 10;
    },
    isOnSale() {
      // Productos con precio < 20 están en oferta (ejemplo)
      return this.product.price < 20;
    },
    stockStatusClass() {
      if (this.isOutOfStock) return 'stock-out';
      if (this.isLowStock) return 'stock-low';
      return 'stock-available';
    },
    stockText() {
      if (this.isOutOfStock) return 'Agotado';
      if (this.isLowStock) return `Solo ${this.product.stock}`;
      return 'Disponible';
    },
    truncatedDescription() {
      const desc = this.product.description || 'Suplemento de alta calidad para tu salud y bienestar.';
      return desc.length > 80 ? desc.substring(0, 80) + '...' : desc;
    }
  },
  mounted() {
    // Cargar favoritos del localStorage
    const favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
    this.isFavorite = favorites.includes(this.product.id);
  },
  methods: {
    async handleAddToCart() {
      if (this.isOutOfStock) return;
      
      this.loading = true;
      try {
        await this.$store.dispatch('addToCart', this.product);
        
        // Animación de éxito
        this.$store.commit('setNotification', {
          type: 'success',
          message: `${this.product.name} agregado al carrito`,
          duration: 2000
        });
      } catch (error) {
        this.$store.commit('setNotification', {
          type: 'error',
          message: error.message || 'Error al agregar al carrito',
          duration: 3000
        });
      } finally {
        setTimeout(() => {
          this.loading = false;
        }, 300);
      }
    },
    handleBuyNow() {
      if (this.isOutOfStock) return;
      this.$emit('buyNow', this.product);
    },
    handleQuickView() {
      this.$emit('quickView', this.product);
    },
    toggleFavorite() {
      this.isFavorite = !this.isFavorite;
      
      // Guardar en localStorage
      let favorites = JSON.parse(localStorage.getItem('favorites') || '[]');
      if (this.isFavorite) {
        favorites.push(this.product.id);
      } else {
        favorites = favorites.filter(id => id !== this.product.id);
      }
      localStorage.setItem('favorites', JSON.stringify(favorites));
      
      this.$emit('toggleFavorite', { productId: this.product.id, isFavorite: this.isFavorite });
      
      // Notificación
      this.$store.commit('setNotification', {
        type: this.isFavorite ? 'success' : 'info',
        message: this.isFavorite ? 'Agregado a favoritos' : 'Eliminado de favoritos',
        duration: 2000
      });
    }
  }
};
</script>

<style scoped>
/* ===== Product Card Container ===== */
.product-card {
  position: relative;
  height: 100%;
  perspective: 1000px;
  transition: transform var(--transition-base);
}

.product-card:hover {
  transform: translateY(-8px);
  z-index: 10;
}

.product-card.out-of-stock {
  opacity: 0.7;
}

/* ===== Card Inner (3D Effect) ===== */
.card-inner {
  position: relative;
  height: 100%;
  background: var(--surface);
  border-radius: var(--radius-xl);
  border: 1px solid var(--border-color);
  overflow: hidden;
  transition: all var(--transition-base);
  box-shadow: var(--shadow-md);
  display: flex;
  flex-direction: column;
}

.product-card:hover .card-inner {
  box-shadow: var(--shadow-2xl);
  border-color: var(--color-primary-light);
}

/* ===== Badges ===== */
.product-badges {
  position: absolute;
  top: var(--space-3);
  left: var(--space-3);
  z-index: 10;
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  animation: fadeInDown 0.5s var(--ease-out);
}

/* ===== Favorite Button ===== */
.favorite-btn {
  position: absolute;
  top: var(--space-3);
  right: var(--space-3);
  z-index: 10;
  width: 40px;
  height: 40px;
  border: none;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: var(--radius-full);
  font-size: var(--text-xl);
  cursor: pointer;
  transition: all var(--transition-base);
  box-shadow: var(--shadow-sm);
  display: flex;
  align-items: center;
  justify-content: center;
}

.favorite-btn:hover {
  transform: scale(1.15);
  box-shadow: var(--shadow-lg);
}

.favorite-btn.active {
  animation: heartBeat 0.5s;
}

@keyframes heartBeat {
  0%, 100% { transform: scale(1); }
  25% { transform: scale(1.3); }
  50% { transform: scale(1.1); }
  75% { transform: scale(1.25); }
}

/* ===== Image Container ===== */
.product-image-container {
  position: relative;
  width: 100%;
  height: 280px;
  background: linear-gradient(135deg, var(--bg-secondary), var(--bg-tertiary));
  overflow: hidden;
  cursor: pointer;
}

.product-image {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: var(--space-6);
  transition: transform var(--transition-slow);
}

.product-card:hover .product-image {
  transform: scale(1.1) rotate(3deg);
}

/* ===== Image Overlay ===== */
.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(5px);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity var(--transition-base);
}

.product-card:hover .image-overlay {
  opacity: 1;
}

.quick-view-btn {
  background: white;
  color: var(--color-primary);
  border: none;
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-full);
  font-weight: var(--font-semibold);
  font-size: var(--text-base);
  cursor: pointer;
  transition: all var(--transition-fast);
  box-shadow: var(--shadow-lg);
}

.quick-view-btn:hover {
  transform: scale(1.05);
  box-shadow: var(--shadow-xl);
}

/* ===== Card Body ===== */
.card-body {
  padding: var(--space-6);
  display: flex;
  flex-direction: column;
  gap: var(--space-3);
  flex: 1;
}

.category-badge {
  align-self: flex-start;
}

.product-name {
  font-size: var(--text-lg);
  font-weight: var(--font-semibold);
  color: var(--text-primary);
  margin: 0;
  line-height: var(--leading-tight);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.product-description {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  line-height: var(--leading-relaxed);
  margin: 0;
  flex: 1;
}

/* ===== Rating ===== */
.product-rating {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  font-size: var(--text-sm);
}

.stars {
  color: #fbbf24;
  font-size: var(--text-base);
}

.rating-count {
  color: var(--text-tertiary);
}

/* ===== Footer ===== */
.product-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: var(--space-3);
  border-top: 1px solid var(--border-color);
}

.price-container {
  display: flex;
  flex-direction: column;
  gap: var(--space-1);
}

.price-old {
  font-size: var(--text-sm);
  color: var(--text-tertiary);
  text-decoration: line-through;
}

.price-current {
  font-size: var(--text-2xl);
  font-weight: var(--font-bold);
  color: var(--color-primary);
}

.stock-indicator {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.stock-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  animation: pulse 2s infinite;
}

.stock-dot.stock-available {
  background: var(--color-success);
}

.stock-dot.stock-low {
  background: var(--color-warning);
}

.stock-dot.stock-out {
  background: var(--color-error);
  animation: none;
}

.stock-text {
  font-size: var(--text-xs);
  font-weight: var(--font-medium);
  color: var(--text-secondary);
}

/* ===== Actions ===== */
.card-actions {
  display: flex;
  gap: var(--space-3);
  margin-top: var(--space-2);
}

/* ===== Responsive ===== */
@media (max-width: 768px) {
  .product-image-container {
    height: 220px;
  }
  
  .card-body {
    padding: var(--space-4);
    gap: var(--space-2);
  }
  
  .product-name {
    font-size: var(--text-base);
  }
  
  .price-current {
    font-size: var(--text-xl);
  }
  
  .card-actions {
    flex-direction: column;
    gap: var(--space-2);
  }
}
</style>
