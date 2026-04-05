<template>
  <header :class="['modern-header', { 'header-scrolled': isScrolled, 'header-menu-open': mobileMenuOpen }]">
    <div class="container">
      <div class="header-content">
        <!-- Logo Section -->
        <div class="logo-section">
          <img src="../assets/logo.png" alt="VMP Logo" class="logo-image" />
          <div class="logo-text">
            <span class="brand-name">VMP Store</span>
            <span class="brand-tagline">Tu salud es nuestra prioridad</span>
          </div>
        </div>

        <!-- Search Bar (Desktop) -->
        <div v-if="isLoggedIn" class="search-bar">
          <span class="search-icon">🔍</span>
          <input
            type="search"
            v-model="searchQuery"
            placeholder="Buscar productos..."
            class="search-input"
            @input="handleSearch"
          />
          <button v-if="searchQuery" class="search-clear" @click="clearSearch">✕</button>
        </div>

        <!-- Actions Section -->
        <div class="header-actions">
          <!-- Theme Toggle -->
          <ThemeToggle />
          
          <!-- Cart Button (Solo si está logueado) -->
          <button v-if="isLoggedIn" class="cart-button" @click="toggleCart" :title="`Carrito (${cartItemCount} items)`">
            <span class="cart-icon">🛒</span>
            <span v-if="cartItemCount > 0" class="cart-badge">{{ cartItemCount }}</span>
          </button>
          
          <!-- User Menu -->
          <div v-if="isLoggedIn" class="user-menu">
            <button class="user-button" @click="toggleUserMenu">
              <span class="user-avatar">{{ userInitials }}</span>
              <span class="user-name">{{ user.username }}</span>
              <span class="dropdown-arrow">▼</span>
            </button>
            
            <!-- Dropdown Menu -->
            <transition name="dropdown">
              <div v-if="userMenuOpen" class="user-dropdown">
                <div class="dropdown-header">
                  <div class="dropdown-user-info">
                    <span class="dropdown-avatar">{{ userInitials }}</span>
                    <div>
                      <div class="dropdown-username">{{ user.username }}</div>
                      <div class="dropdown-email">{{ user.email || 'usuario@vmp.com' }}</div>
                    </div>
                  </div>
                </div>
                <div class="dropdown-divider"></div>
                <button class="dropdown-item" @click="logout">
                  <span class="dropdown-icon">🚪</span>
                  Cerrar Sesión
                </button>
              </div>
            </transition>
          </div>

          <!-- Mobile Menu Toggle -->
          <button class="mobile-menu-toggle" @click="toggleMobileMenu" aria-label="Toggle menu">
            <span class="hamburger-icon" :class="{ 'active': mobileMenuOpen }">
              <span></span>
              <span></span>
              <span></span>
            </span>
          </button>
        </div>
      </div>

      <!-- Mobile Search Bar -->
      <transition name="slide-down">
        <div v-if="isLoggedIn && mobileMenuOpen" class="mobile-search">
          <span class="search-icon">🔍</span>
          <input
            type="search"
            v-model="searchQuery"
            placeholder="Buscar productos..."
            class="search-input"
            @input="handleSearch"
          />
          <button v-if="searchQuery" class="search-clear" @click="clearSearch">✕</button>
        </div>
      </transition>
    </div>

    <!-- Progress Bar (Loading indicator) -->
    <div v-if="loading" class="progress-bar">
      <div class="progress-bar-fill progress-bar-animated"></div>
    </div>
  </header>
</template>

<script>
import ThemeToggle from './ThemeToggle.vue';

export default {
  name: 'ModernHeader',
  components: {
    ThemeToggle
  },
  data() {
    return {
      isScrolled: false,
      mobileMenuOpen: false,
      userMenuOpen: false,
      searchQuery: '',
      loading: false
    };
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.isLoggedIn;
    },
    user() {
      return this.$store.state.user;
    },
    cartItemCount() {
      return this.$store.getters.cartItemCount;
    },
    userInitials() {
      if (!this.user.username) return 'U';
      return this.user.username
        .split(' ')
        .map(word => word[0])
        .join('')
        .toUpperCase()
        .slice(0, 2);
    }
  },
  mounted() {
    window.addEventListener('scroll', this.handleScroll);
    document.addEventListener('click', this.handleClickOutside);
  },
  beforeUnmount() {
    window.removeEventListener('scroll', this.handleScroll);
    document.removeEventListener('click', this.handleClickOutside);
  },
  methods: {
    handleScroll() {
      this.isScrolled = window.scrollY > 20;
    },
    toggleCart() {
      this.$emit('toggle-cart');
    },
    toggleMobileMenu() {
      this.mobileMenuOpen = !this.mobileMenuOpen;
      if (this.mobileMenuOpen) {
        this.userMenuOpen = false;
      }
    },
    toggleUserMenu() {
      this.userMenuOpen = !this.userMenuOpen;
    },
    handleClickOutside(event) {
      if (!event.target.closest('.user-menu')) {
        this.userMenuOpen = false;
      }
      if (!event.target.closest('.mobile-menu-toggle') && !event.target.closest('.mobile-search')) {
        this.mobileMenuOpen = false;
      }
    },
    handleSearch() {
      this.$emit('search', this.searchQuery);
    },
    clearSearch() {
      this.searchQuery = '';
      this.$emit('search', '');
    },
    logout() {
      this.$store.commit('logout');
      this.userMenuOpen = false;
      this.mobileMenuOpen = false;
    }
  }
};
</script>

<style scoped>
/* ===== Header Base ===== */
.modern-header {
  position: sticky;
  top: 0;
  z-index: var(--z-sticky);
  background: linear-gradient(135deg, var(--color-primary), var(--color-secondary));
  color: white;
  padding: var(--space-4) 0;
  box-shadow: var(--shadow-sm);
  transition: all var(--transition-base);
}

.header-scrolled {
  padding: var(--space-3) 0;
  box-shadow: var(--shadow-lg);
  background: rgba(99, 102, 241, 0.95);
  backdrop-filter: blur(10px);
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: var(--space-6);
}

/* ===== Logo Section ===== */
.logo-section {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  flex-shrink: 0;
}

.logo-image {
  height: 50px;
  width: auto;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
  transition: transform var(--transition-base);
}

.logo-image:hover {
  transform: scale(1.05) rotate(5deg);
}

.header-scrolled .logo-image {
  height: 40px;
}

.logo-text {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.brand-name {
  font-size: var(--text-xl);
  font-weight: var(--font-bold);
  line-height: 1;
}

.brand-tagline {
  font-size: var(--text-xs);
  opacity: 0.9;
  font-weight: var(--font-normal);
}

/* ===== Search Bar ===== */
.search-bar {
  position: relative;
  flex: 1;
  max-width: 500px;
  display: flex;
  align-items: center;
}

.search-icon {
  position: absolute;
  left: var(--space-4);
  font-size: var(--text-lg);
  opacity: 0.7;
  pointer-events: none;
}

.search-input {
  width: 100%;
  padding: var(--space-3) var(--space-12);
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-radius: var(--radius-full);
  color: white;
  font-size: var(--text-base);
  backdrop-filter: blur(10px);
  transition: all var(--transition-base);
}

.search-input::placeholder {
  color: rgba(255, 255, 255, 0.7);
}

.search-input:focus {
  outline: none;
  background: rgba(255, 255, 255, 0.25);
  border-color: rgba(255, 255, 255, 0.5);
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
}

.search-clear {
  position: absolute;
  right: var(--space-4);
  background: rgba(255, 255, 255, 0.2);
  border: none;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  color: white;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: var(--text-sm);
  transition: all var(--transition-fast);
}

.search-clear:hover {
  background: rgba(255, 255, 255, 0.3);
}

/* ===== Header Actions ===== */
.header-actions {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

/* ===== Cart Button ===== */
.cart-button {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: var(--radius-full);
  color: white;
  font-size: var(--text-xl);
  cursor: pointer;
  transition: all var(--transition-base);
  backdrop-filter: blur(10px);
}

.cart-button:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: scale(1.1);
}

.cart-icon {
  display: block;
}

.cart-badge {
  position: absolute;
  top: -4px;
  right: -4px;
  background: var(--color-error);
  color: white;
  font-size: var(--text-xs);
  font-weight: var(--font-bold);
  padding: 2px 6px;
  border-radius: var(--radius-full);
  min-width: 20px;
  text-align: center;
  box-shadow: var(--shadow-md);
  animation: pulse 2s infinite;
}

/* ===== User Menu ===== */
.user-menu {
  position: relative;
}

.user-button {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-4);
  background: rgba(255, 255, 255, 0.15);
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: var(--radius-full);
  color: white;
  cursor: pointer;
  transition: all var(--transition-base);
  backdrop-filter: blur(10px);
}

.user-button:hover {
  background: rgba(255, 255, 255, 0.25);
}

.user-avatar {
  width: 32px;
  height: 32px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: var(--font-bold);
  font-size: var(--text-sm);
}

.user-name {
  font-weight: var(--font-medium);
  font-size: var(--text-sm);
}

.dropdown-arrow {
  font-size: 10px;
  transition: transform var(--transition-fast);
}

.user-menu:hover .dropdown-arrow {
  transform: rotate(180deg);
}

/* ===== User Dropdown ===== */
.user-dropdown {
  position: absolute;
  top: calc(100% + var(--space-2));
  right: 0;
  min-width: 250px;
  background: var(--surface);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-xl);
  border: 1px solid var(--border-color);
  overflow: hidden;
  z-index: var(--z-dropdown);
}

.dropdown-header {
  padding: var(--space-4);
  background: var(--bg-secondary);
}

.dropdown-user-info {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.dropdown-avatar {
  width: 48px;
  height: 48px;
  background: var(--color-primary);
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: var(--font-bold);
  font-size: var(--text-lg);
}

.dropdown-username {
  font-weight: var(--font-semibold);
  color: var(--text-primary);
  font-size: var(--text-base);
}

.dropdown-email {
  font-size: var(--text-sm);
  color: var(--text-secondary);
}

.dropdown-divider {
  height: 1px;
  background: var(--border-color);
}

.dropdown-item {
  width: 100%;
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3) var(--space-4);
  background: transparent;
  border: none;
  color: var(--text-primary);
  font-size: var(--text-base);
  cursor: pointer;
  transition: all var(--transition-fast);
  text-align: left;
}

.dropdown-item:hover {
  background: var(--bg-secondary);
  color: var(--color-primary);
}

.dropdown-icon {
  font-size: var(--text-lg);
}

/* ===== Mobile Menu Toggle ===== */
.mobile-menu-toggle {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: var(--space-2);
}

.hamburger-icon {
  display: flex;
  flex-direction: column;
  gap: 5px;
  width: 24px;
}

.hamburger-icon span {
  display: block;
  width: 100%;
  height: 3px;
  background: white;
  border-radius: var(--radius-full);
  transition: all var(--transition-base);
}

.hamburger-icon.active span:nth-child(1) {
  transform: rotate(45deg) translate(7px, 7px);
}

.hamburger-icon.active span:nth-child(2) {
  opacity: 0;
}

.hamburger-icon.active span:nth-child(3) {
  transform: rotate(-45deg) translate(7px, -7px);
}

/* ===== Mobile Search ===== */
.mobile-search {
  display: none;
  position: relative;
  margin-top: var(--space-4);
  padding-top: var(--space-4);
  border-top: 1px solid rgba(255, 255, 255, 0.2);
}

/* ===== Progress Bar ===== */
.progress-bar {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 3px;
  background: rgba(255, 255, 255, 0.2);
}

/* ===== Transitions ===== */
.dropdown-enter-active,
.dropdown-leave-active {
  transition: all var(--transition-base);
  transform-origin: top;
}

.dropdown-enter-from,
.dropdown-leave-to {
  opacity: 0;
  transform: translateY(-10px) scale(0.95);
}

.slide-down-enter-active,
.slide-down-leave-active {
  transition: all var(--transition-base);
  max-height: 200px;
}

.slide-down-enter-from,
.slide-down-leave-to {
  max-height: 0;
  opacity: 0;
}

/* ===== Responsive ===== */
@media (max-width: 1024px) {
  .search-bar {
    display: none;
  }
  
  .mobile-search {
    display: flex;
    align-items: center;
  }
}

@media (max-width: 768px) {
  .modern-header {
    padding: var(--space-3) 0;
  }
  
  .brand-tagline {
    display: none;
  }
  
  .user-name {
    display: none;
  }
  
  .mobile-menu-toggle {
    display: block;
  }
  
  .logo-image {
    height: 40px;
  }
}

@media (max-width: 640px) {
  .brand-name {
    font-size: var(--text-base);
  }
  
  .logo-text {
    display: none;
  }
  
  .header-actions {
    gap: var(--space-2);
  }
}
</style>
