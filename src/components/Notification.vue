<template>
  <Transition name="slide-fade">
    <div v-if="notification" :class="['notification', notification.type]">
      <div class="notification-content">
        <span class="notification-icon">{{ getIcon() }}</span>
        <span class="notification-message">{{ notification.message }}</span>
        <button @click="close" class="notification-close">&times;</button>
      </div>
    </div>
  </Transition>
</template>

<script>
export default {
  computed: {
    notification() {
      return this.$store.state.notification;
    },
  },
  methods: {
    getIcon() {
      const icons = {
        success: '✓',
        error: '✕',
        warning: '⚠',
        info: 'ℹ',
      };
      return icons[this.notification?.type] || 'ℹ';
    },
    close() {
      this.$store.commit('CLEAR_NOTIFICATION');
    },
  },
};
</script>

<style scoped>
.notification {
  position: fixed;
  top: 20px;
  right: 20px;
  min-width: 300px;
  max-width: 500px;
  padding: 16px 20px;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 9999;
  animation: slideIn 0.3s ease-out;
}

.notification-content {
  display: flex;
  align-items: center;
  gap: 12px;
}

.notification-icon {
  font-size: 20px;
  font-weight: bold;
}

.notification-message {
  flex: 1;
  color: white;
  font-size: 14px;
}

.notification-close {
  background: none;
  border: none;
  color: white;
  font-size: 24px;
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0.8;
  transition: opacity 0.2s;
}

.notification-close:hover {
  opacity: 1;
}

.notification.success {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
}

.notification.error {
  background: linear-gradient(135deg, #c0392b 0%, #e74c3c 100%);
}

.notification.warning {
  background: linear-gradient(135deg, #f39c12 0%, #f1c40f 100%);
}

.notification.info {
  background: linear-gradient(135deg, #2980b9 0%, #3498db 100%);
}

.slide-fade-enter-active {
  transition: all 0.3s ease-out;
}

.slide-fade-leave-active {
  transition: all 0.3s ease-in;
}

.slide-fade-enter-from {
  transform: translateX(100%);
  opacity: 0;
}

.slide-fade-leave-to {
  transform: translateY(-20px);
  opacity: 0;
}
</style>
