<template>
  <button
    :class="buttonClasses"
    :type="type"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <!-- Loading Spinner -->
    <span v-if="loading" class="btn-spinner">
      <span class="spinner spinner-sm"></span>
    </span>
    
    <!-- Icon Left -->
    <span v-if="$slots.iconLeft && !loading" class="btn-icon-left">
      <slot name="iconLeft"></slot>
    </span>
    
    <!-- Text Content -->
    <span class="btn-text">
      <slot></slot>
    </span>
    
    <!-- Icon Right -->
    <span v-if="$slots.iconRight && !loading" class="btn-icon-right">
      <slot name="iconRight"></slot>
    </span>
  </button>
</template>

<script>
export default {
  name: 'BaseButton',
  props: {
    variant: {
      type: String,
      default: 'primary',
      validator: (value) => ['primary', 'secondary', 'success', 'danger', 'warning', 'ghost', 'outline'].includes(value)
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['xs', 'sm', 'md', 'lg', 'xl'].includes(value)
    },
    type: {
      type: String,
      default: 'button',
      validator: (value) => ['button', 'submit', 'reset'].includes(value)
    },
    disabled: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    fullWidth: {
      type: Boolean,
      default: false
    },
    rounded: {
      type: Boolean,
      default: false
    }
  },
  emits: ['click'],
  computed: {
    buttonClasses() {
      return [
        'btn',
        `btn-${this.variant}`,
        `btn-${this.size}`,
        {
          'btn-full-width': this.fullWidth,
          'btn-rounded': this.rounded,
          'btn-loading': this.loading,
          'btn-disabled': this.disabled
        }
      ];
    }
  },
  methods: {
    handleClick(event) {
      if (!this.disabled && !this.loading) {
        this.$emit('click', event);
      }
    }
  }
};
</script>

<style scoped>
/* ===== Base Button Styles ===== */
.btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  font-family: var(--font-sans);
  font-weight: var(--font-medium);
  text-align: center;
  border: none;
  cursor: pointer;
  transition: all var(--transition-base);
  text-decoration: none;
  white-space: nowrap;
  user-select: none;
  overflow: hidden;
}

.btn:focus-visible {
  outline: 2px solid var(--border-color-focus);
  outline-offset: 2px;
}

/* ===== Sizes ===== */
.btn-xs {
  font-size: var(--text-xs);
  padding: var(--space-1) var(--space-3);
  border-radius: var(--radius-sm);
  min-height: 28px;
}

.btn-sm {
  font-size: var(--text-sm);
  padding: var(--space-2) var(--space-4);
  border-radius: var(--radius-base);
  min-height: 36px;
}

.btn-md {
  font-size: var(--text-base);
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-md);
  min-height: 44px;
}

.btn-lg {
  font-size: var(--text-lg);
  padding: var(--space-4) var(--space-8);
  border-radius: var(--radius-lg);
  min-height: 52px;
}

.btn-xl {
  font-size: var(--text-xl);
  padding: var(--space-5) var(--space-10);
  border-radius: var(--radius-lg);
  min-height: 60px;
}

/* ===== Variants ===== */

/* Primary */
.btn-primary {
  background: linear-gradient(135deg, var(--color-primary), var(--color-primary-dark));
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-primary:hover:not(:disabled) {
  background: linear-gradient(135deg, var(--color-primary-dark), var(--color-primary));
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

.btn-primary:active:not(:disabled) {
  transform: translateY(0);
  box-shadow: var(--shadow-sm);
}

/* Secondary */
.btn-secondary {
  background: linear-gradient(135deg, var(--color-secondary), var(--color-secondary-dark));
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-secondary:hover:not(:disabled) {
  background: linear-gradient(135deg, var(--color-secondary-dark), var(--color-secondary));
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

/* Success */
.btn-success {
  background: linear-gradient(135deg, var(--color-success), #0d9668);
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-success:hover:not(:disabled) {
  background: linear-gradient(135deg, #0d9668, var(--color-success));
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

/* Danger */
.btn-danger {
  background: linear-gradient(135deg, var(--color-error), #dc2626);
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-danger:hover:not(:disabled) {
  background: linear-gradient(135deg, #dc2626, var(--color-error));
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

/* Warning */
.btn-warning {
  background: linear-gradient(135deg, var(--color-warning), #d97706);
  color: white;
  box-shadow: var(--shadow-sm);
}

.btn-warning:hover:not(:disabled) {
  background: linear-gradient(135deg, #d97706, var(--color-warning));
  box-shadow: var(--shadow-md);
  transform: translateY(-2px);
}

/* Ghost */
.btn-ghost {
  background: transparent;
  color: var(--text-primary);
}

.btn-ghost:hover:not(:disabled) {
  background: var(--surface-hover);
}

/* Outline */
.btn-outline {
  background: transparent;
  border: 2px solid var(--color-primary);
  color: var(--color-primary);
}

.btn-outline:hover:not(:disabled) {
  background: var(--color-primary);
  color: white;
}

/* ===== States ===== */
.btn-disabled,
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

.btn-loading {
  pointer-events: none;
}

.btn-loading .btn-text {
  opacity: 0.7;
}

/* ===== Modifiers ===== */
.btn-full-width {
  width: 100%;
}

.btn-rounded {
  border-radius: var(--radius-full);
}

/* ===== Icons ===== */
.btn-spinner {
  display: flex;
  align-items: center;
}

.btn-icon-left,
.btn-icon-right {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* ===== Ripple Effect ===== */
.btn::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.3);
  transform: translate(-50%, -50%);
  transition: width 0.6s, height 0.6s;
}

.btn:active::before {
  width: 300px;
  height: 300px;
}
</style>
