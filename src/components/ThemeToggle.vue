<template>
  <button
    class="theme-toggle"
    @click="toggleTheme"
    :aria-label="isDark ? 'Switch to light mode' : 'Switch to dark mode'"
    :title="isDark ? 'Modo Claro' : 'Modo Oscuro'"
  >
    <transition name="fade" mode="out-in">
      <span v-if="isDark" key="dark" class="theme-icon">🌙</span>
      <span v-else key="light" class="theme-icon">☀️</span>
    </transition>
  </button>
</template>

<script>
export default {
  name: 'ThemeToggle',
  data() {
    return {
      isDark: false
    };
  },
  mounted() {
    // Detectar preferencia del sistema
    const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
    
    // Cargar preferencia guardada o usar preferencia del sistema
    const savedTheme = localStorage.getItem('theme');
    this.isDark = savedTheme ? savedTheme === 'dark' : prefersDark;
    
    this.applyTheme();
    
    // Escuchar cambios en preferencia del sistema
    window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (e) => {
      if (!localStorage.getItem('theme')) {
        this.isDark = e.matches;
        this.applyTheme();
      }
    });
  },
  methods: {
    toggleTheme() {
      this.isDark = !this.isDark;
      this.applyTheme();
      localStorage.setItem('theme', this.isDark ? 'dark' : 'light');
    },
    applyTheme() {
      if (this.isDark) {
        document.documentElement.setAttribute('data-theme', 'dark');
      } else {
        document.documentElement.removeAttribute('data-theme');
      }
    }
  }
};
</script>

<style scoped>
.theme-toggle {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border: 2px solid var(--border-color);
  border-radius: var(--radius-full);
  background-color: var(--surface);
  cursor: pointer;
  transition: all var(--transition-base);
  overflow: hidden;
}

.theme-toggle:hover {
  border-color: var(--color-primary);
  transform: scale(1.1);
  box-shadow: var(--shadow-md);
}

.theme-toggle:active {
  transform: scale(0.95);
}

.theme-icon {
  font-size: 1.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform var(--transition-base);
}

/* Fade transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: scale(0.5) rotate(-180deg);
}

.fade-leave-to {
  opacity: 0;
  transform: scale(0.5) rotate(180deg);
}

/* Focus state */
.theme-toggle:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}
</style>
