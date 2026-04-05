<template>
  <div :class="['input-wrapper', { 'input-error': error, 'input-disabled': disabled }]">
    <!-- Label -->
    <label v-if="label" :for="inputId" class="input-label">
      {{ label }}
      <span v-if="required" class="input-required">*</span>
    </label>
    
    <!-- Input Container -->
    <div class="input-container">
      <!-- Icon Left -->
      <span v-if="$slots.iconLeft" class="input-icon input-icon-left">
        <slot name="iconLeft"></slot>
      </span>
      
      <!-- Input/Textarea -->
      <component
        :is="multiline ? 'textarea' : 'input'"
        :id="inputId"
        ref="inputRef"
        v-model="internalValue"
        :type="inputType"
        :placeholder="placeholder"
        :disabled="disabled"
        :readonly="readonly"
        :maxlength="maxlength"
        :rows="rows"
        :class="inputClasses"
        @focus="handleFocus"
        @blur="handleBlur"
        @input="handleInput"
      />
      
      <!-- Icon Right / Clear Button -->
      <span v-if="$slots.iconRight || (clearable && internalValue)" class="input-icon input-icon-right">
        <button
          v-if="clearable && internalValue"
          type="button"
          class="input-clear"
          @click="clearInput"
          aria-label="Clear input"
        >
          ✕
        </button>
        <slot v-else name="iconRight"></slot>
      </span>
      
      <!-- Password Toggle -->
      <button
        v-if="type === 'password'"
        type="button"
        class="input-icon input-icon-right input-toggle-password"
        @click="togglePasswordVisibility"
        aria-label="Toggle password visibility"
      >
        {{ showPassword ? '👁️' : '👁️‍🗨️' }}
      </button>
    </div>
    
    <!-- Helper Text / Error Message -->
    <div v-if="helperText || error" class="input-helper">
      <span v-if="error" class="input-error-text">{{ error }}</span>
      <span v-else-if="helperText" class="input-helper-text">{{ helperText }}</span>
    </div>
    
    <!-- Character Counter -->
    <div v-if="maxlength && showCounter" class="input-counter">
      {{ internalValue.length }} / {{ maxlength }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'BaseInput',
  props: {
    modelValue: {
      type: [String, Number],
      default: ''
    },
    type: {
      type: String,
      default: 'text',
      validator: (value) => ['text', 'email', 'password', 'number', 'tel', 'url', 'search'].includes(value)
    },
    label: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    },
    helperText: {
      type: String,
      default: ''
    },
    error: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    readonly: {
      type: Boolean,
      default: false
    },
    required: {
      type: Boolean,
      default: false
    },
    clearable: {
      type: Boolean,
      default: false
    },
    multiline: {
      type: Boolean,
      default: false
    },
    rows: {
      type: Number,
      default: 3
    },
    maxlength: {
      type: Number,
      default: null
    },
    showCounter: {
      type: Boolean,
      default: false
    },
    size: {
      type: String,
      default: 'md',
      validator: (value) => ['sm', 'md', 'lg'].includes(value)
    }
  },
  emits: ['update:modelValue', 'focus', 'blur', 'input'],
  data() {
    return {
      inputId: `input-${Math.random().toString(36).substr(2, 9)}`,
      isFocused: false,
      showPassword: false
    };
  },
  computed: {
    internalValue: {
      get() {
        return this.modelValue;
      },
      set(value) {
        this.$emit('update:modelValue', value);
      }
    },
    inputType() {
      if (this.type === 'password') {
        return this.showPassword ? 'text' : 'password';
      }
      return this.type;
    },
    inputClasses() {
      return [
        'input',
        `input-${this.size}`,
        {
          'input-with-icon-left': this.$slots.iconLeft,
          'input-with-icon-right': this.$slots.iconRight || this.clearable || this.type === 'password',
          'input-focused': this.isFocused
        }
      ];
    }
  },
  methods: {
    handleFocus(event) {
      this.isFocused = true;
      this.$emit('focus', event);
    },
    handleBlur(event) {
      this.isFocused = false;
      this.$emit('blur', event);
    },
    handleInput(event) {
      this.$emit('input', event.target.value);
    },
    clearInput() {
      this.internalValue = '';
      this.$refs.inputRef.focus();
    },
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword;
    },
    focus() {
      this.$refs.inputRef.focus();
    }
  }
};
</script>

<style scoped>
/* ===== Input Wrapper ===== */
.input-wrapper {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
  width: 100%;
}

/* ===== Label ===== */
.input-label {
  font-size: var(--text-sm);
  font-weight: var(--font-medium);
  color: var(--text-primary);
}

.input-required {
  color: var(--color-error);
  margin-left: var(--space-1);
}

/* ===== Input Container ===== */
.input-container {
  position: relative;
  display: flex;
  align-items: center;
}

/* ===== Input Base ===== */
.input {
  width: 100%;
  font-family: var(--font-sans);
  font-size: var(--text-base);
  color: var(--text-primary);
  background-color: var(--surface);
  border: 2px solid var(--border-color);
  border-radius: var(--radius-md);
  transition: all var(--transition-base);
  outline: none;
}

.input::placeholder {
  color: var(--text-tertiary);
}

.input:focus {
  border-color: var(--border-color-focus);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.input:hover:not(:disabled) {
  border-color: var(--border-color-hover);
}

.input:disabled {
  background-color: var(--bg-tertiary);
  cursor: not-allowed;
  opacity: 0.6;
}

/* ===== Sizes ===== */
.input-sm {
  padding: var(--space-2) var(--space-3);
  font-size: var(--text-sm);
  min-height: 36px;
}

.input-md {
  padding: var(--space-3) var(--space-4);
  font-size: var(--text-base);
  min-height: 44px;
}

.input-lg {
  padding: var(--space-4) var(--space-6);
  font-size: var(--text-lg);
  min-height: 52px;
}

/* ===== With Icons ===== */
.input-with-icon-left {
  padding-left: var(--space-10);
}

.input-with-icon-right {
  padding-right: var(--space-10);
}

/* ===== Textarea ===== */
textarea.input {
  resize: vertical;
  min-height: 100px;
}

/* ===== Icons ===== */
.input-icon {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-secondary);
  transition: color var(--transition-fast);
}

.input-icon-left {
  left: var(--space-3);
}

.input-icon-right {
  right: var(--space-3);
}

.input:focus ~ .input-icon {
  color: var(--color-primary);
}

/* ===== Clear Button ===== */
.input-clear {
  background: none;
  border: none;
  padding: var(--space-1);
  cursor: pointer;
  color: var(--text-secondary);
  font-size: var(--text-lg);
  line-height: 1;
  transition: color var(--transition-fast);
}

.input-clear:hover {
  color: var(--color-error);
}

/* ===== Password Toggle ===== */
.input-toggle-password {
  background: none;
  border: none;
  padding: var(--space-1);
  cursor: pointer;
  font-size: var(--text-lg);
  line-height: 1;
  transition: opacity var(--transition-fast);
}

.input-toggle-password:hover {
  opacity: 0.7;
}

/* ===== Helper Text ===== */
.input-helper {
  font-size: var(--text-sm);
  min-height: 20px;
}

.input-helper-text {
  color: var(--text-secondary);
}

.input-error-text {
  color: var(--color-error);
  font-weight: var(--font-medium);
}

/* ===== Error State ===== */
.input-error .input {
  border-color: var(--color-error);
}

.input-error .input:focus {
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

/* ===== Disabled State ===== */
.input-disabled {
  opacity: 0.6;
  pointer-events: none;
}

/* ===== Character Counter ===== */
.input-counter {
  font-size: var(--text-xs);
  color: var(--text-tertiary);
  text-align: right;
  margin-top: calc(var(--space-2) * -1);
}
</style>
