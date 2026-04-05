<template>
  <div :class="cardClasses" @click="handleClick">
    <!-- Header -->
    <div v-if="$slots.header || title" class="card-header">
      <slot name="header">
        <h3 v-if="title" class="card-title">{{ title }}</h3>
        <p v-if="subtitle" class="card-subtitle">{{ subtitle }}</p>
      </slot>
    </div>
    
    <!-- Image -->
    <div v-if="image || $slots.image" class="card-image">
      <slot name="image">
        <img :src="image" :alt="imageAlt" loading="lazy" />
      </slot>
    </div>
    
    <!-- Body -->
    <div v-if="$slots.default" class="card-body">
      <slot></slot>
    </div>
    
    <!-- Footer -->
    <div v-if="$slots.footer" class="card-footer">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseCard',
  props: {
    title: {
      type: String,
      default: ''
    },
    subtitle: {
      type: String,
      default: ''
    },
    image: {
      type: String,
      default: ''
    },
    imageAlt: {
      type: String,
      default: 'Card image'
    },
    variant: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'outlined', 'elevated', 'glass'].includes(value)
    },
    hoverable: {
      type: Boolean,
      default: false
    },
    clickable: {
      type: Boolean,
      default: false
    },
    noPadding: {
      type: Boolean,
      default: false
    }
  },
  emits: ['click'],
  computed: {
    cardClasses() {
      return [
        'card',
        `card-${this.variant}`,
        {
          'card-hoverable': this.hoverable,
          'card-clickable': this.clickable,
          'card-no-padding': this.noPadding
        }
      ];
    }
  },
  methods: {
    handleClick(event) {
      if (this.clickable) {
        this.$emit('click', event);
      }
    }
  }
};
</script>

<style scoped>
/* ===== Card Base ===== */
.card {
  display: flex;
  flex-direction: column;
  background-color: var(--surface);
  border-radius: var(--radius-lg);
  overflow: hidden;
  transition: all var(--transition-base);
}

/* ===== Variants ===== */
.card-default {
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
}

.card-outlined {
  border: 2px solid var(--border-color);
}

.card-elevated {
  box-shadow: var(--shadow-lg);
}

.card-glass {
  background: var(--glass-bg);
  backdrop-filter: var(--blur);
  -webkit-backdrop-filter: var(--blur);
  border: 1px solid var(--glass-border);
  box-shadow: var(--glass-shadow);
}

/* ===== States ===== */
.card-hoverable:hover {
  box-shadow: var(--shadow-xl);
  transform: translateY(-4px);
}

.card-clickable {
  cursor: pointer;
  user-select: none;
}

.card-clickable:active {
  transform: scale(0.98);
}

/* ===== Card Sections ===== */
.card-header {
  padding: var(--space-6);
  border-bottom: 1px solid var(--border-color);
}

.card-no-padding .card-header {
  padding: 0;
  border-bottom: none;
}

.card-title {
  font-size: var(--text-xl);
  font-weight: var(--font-semibold);
  color: var(--text-primary);
  margin: 0;
}

.card-subtitle {
  font-size: var(--text-sm);
  color: var(--text-secondary);
  margin-top: var(--space-1);
  margin-bottom: 0;
}

.card-image {
  width: 100%;
  overflow: hidden;
  background-color: var(--bg-secondary);
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform var(--transition-base);
}

.card-hoverable:hover .card-image img {
  transform: scale(1.05);
}

.card-body {
  padding: var(--space-6);
  flex: 1;
}

.card-no-padding .card-body {
  padding: 0;
}

.card-footer {
  padding: var(--space-6);
  border-top: 1px solid var(--border-color);
  background-color: var(--bg-secondary);
}

.card-no-padding .card-footer {
  padding: 0;
  border-top: none;
  background-color: transparent;
}

/* ===== Responsive ===== */
@media (max-width: 768px) {
  .card-header,
  .card-body,
  .card-footer {
    padding: var(--space-4);
  }
  
  .card-title {
    font-size: var(--text-lg);
  }
}
</style>
