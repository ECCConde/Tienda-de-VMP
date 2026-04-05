<template>
  <span :class="badgeClasses">
    <span v-if="$slots.icon" class="badge-icon">
      <slot name="icon"></slot>
    </span>
    <span class="badge-text">
      <slot></slot>
    </span>
    <button
      v-if="removable"
      type="button"
      class="badge-remove"
      @click.stop="handleRemove"
      aria-label="Remove badge"
    >
      ✕
    </button>
  </span>
</template>

<script>
export default {
  name: 'BaseBadge',
  props: {
    variant: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'primary', 'secondary', 'success', 'warning', 'error', 'info'].includes(value)
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    },
    outlined: {
      type: Boolean,
      default: false
    },
    rounded: {
      type: Boolean,
      default: false
    },
    removable: {
      type: Boolean,
      default: false
    },
    dot: {
      type: Boolean,
      default: false
    }
  },
  emits: ['remove'],
  computed: {
    badgeClasses() {
      return [
        'badge',
        `badge-${this.variant}`,
        `badge-${this.size}`,
        {
          'badge-outlined': this.outlined,
          'badge-rounded': this.rounded,
          'badge-dot': this.dot
        }
      ];
    }
  },
  methods: {
    handleRemove(event) {
      this.$emit('remove', event);
    }
  }
};
</script>

<style scoped>
/* ===== Badge Base ===== */
.badge {
  display: inline-flex;
  align-items: center;
  gap: var(--space-1);
  font-family: var(--font-sans);
  font-weight: var(--font-medium);
  white-space: nowrap;
  border-radius: var(--radius-base);
  transition: all var(--transition-fast);
}

/* ===== Sizes ===== */
.badge-sm {
  font-size: var(--text-xs);
  padding: var(--space-1) var(--space-2);
  gap: 2px;
}

.badge-md {
  font-size: var(--text-sm);
  padding: var(--space-1) var(--space-3);
}

.badge-lg {
  font-size: var(--text-base);
  padding: var(--space-2) var(--space-4);
}

/* ===== Variants (Solid) ===== */
.badge-default {
  background-color: var(--gray-200);
  color: var(--gray-700);
}

.badge-primary {
  background-color: var(--color-primary);
  color: white;
}

.badge-secondary {
  background-color: var(--color-secondary);
  color: white;
}

.badge-success {
  background-color: var(--color-success);
  color: white;
}

.badge-warning {
  background-color: var(--color-warning);
  color: white;
}

.badge-error {
  background-color: var(--color-error);
  color: white;
}

.badge-info {
  background-color: var(--color-info);
  color: white;
}

/* ===== Outlined Variants ===== */
.badge-outlined.badge-default {
  background-color: transparent;
  color: var(--gray-700);
  border: 1.5px solid var(--gray-300);
}

.badge-outlined.badge-primary {
  background-color: transparent;
  color: var(--color-primary);
  border: 1.5px solid var(--color-primary);
}

.badge-outlined.badge-secondary {
  background-color: transparent;
  color: var(--color-secondary);
  border: 1.5px solid var(--color-secondary);
}

.badge-outlined.badge-success {
  background-color: transparent;
  color: var(--color-success);
  border: 1.5px solid var(--color-success);
}

.badge-outlined.badge-warning {
  background-color: transparent;
  color: var(--color-warning);
  border: 1.5px solid var(--color-warning);
}

.badge-outlined.badge-error {
  background-color: transparent;
  color: var(--color-error);
  border: 1.5px solid var(--color-error);
}

.badge-outlined.badge-info {
  background-color: transparent;
  color: var(--color-info);
  border: 1.5px solid var(--color-info);
}

/* ===== Modifiers ===== */
.badge-rounded {
  border-radius: var(--radius-full);
}

.badge-dot::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background-color: currentColor;
}

/* ===== Icon ===== */
.badge-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1em;
}

/* ===== Remove Button ===== */
.badge-remove {
  display: flex;
  align-items: center;
  justify-content: center;
  background: none;
  border: none;
  padding: 0;
  margin-left: var(--space-1);
  cursor: pointer;
  color: currentColor;
  opacity: 0.7;
  font-size: 1em;
  line-height: 1;
  transition: opacity var(--transition-fast);
}

.badge-remove:hover {
  opacity: 1;
}

/* ===== Dark Mode Adjustments ===== */
[data-theme="dark"] .badge-default {
  background-color: var(--gray-700);
  color: var(--gray-200);
}

[data-theme="dark"] .badge-outlined.badge-default {
  color: var(--gray-300);
  border-color: var(--gray-600);
}
</style>
