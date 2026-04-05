<template>
  <div class="auth-form-container">
    <div class="auth-form-card">
      <div class="auth-header">
        <h2>{{ isLogin ? 'Iniciar Sesión' : 'Crear Cuenta' }}</h2>
        <p class="auth-subtitle">
          {{ isLogin ? 'Bienvenido de vuelta a VMP Store' : '¡Únete a nuestra comunidad!' }}
        </p>
      </div>
      
      <form @submit.prevent="submitForm" class="auth-form">
        <div class="form-group">
          <label for="username">
            <span class="label-icon">👤</span>
            Nombre de usuario
          </label>
          <input 
            type="text" 
            id="username"
            v-model="username" 
            placeholder="Ingresa tu nombre de usuario"
            required
          >
        </div>

        <div class="form-group">
          <label for="password">
            <span class="label-icon">🔒</span>
            Contraseña
          </label>
          <input 
            type="password" 
            id="password"
            v-model="password" 
            placeholder="Ingresa tu contraseña"
            required
          >
        </div>

        <button 
          type="submit" 
          :class="['btn-submit', isLogin ? 'btn-login' : 'btn-register']"
        >
          {{ isLogin ? 'Iniciar Sesión' : 'Registrarse' }}
        </button>
      </form>
      
      <div class="auth-toggle">
        <p>
          {{ isLogin ? '¿No tienes cuenta?' : '¿Ya tienes cuenta?' }}
        </p>
        <button @click="toggleForm" class="toggle-button">
          {{ isLogin ? 'Regístrate aquí' : 'Inicia sesión aquí' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      isLogin: true,
      username: '',
      password: '',
    };
  },
  methods: {
    toggleForm() {
      this.isLogin = !this.isLogin;
      this.username = '';
      this.password = '';
    },
    submitForm() {
      if (!this.username.trim() || !this.password.trim()) {
        alert('Por favor completa todos los campos');
        return;
      }

      const userData = {
        username: this.username.trim(),
        password: this.password,
      };

      if (this.isLogin) {
        this.$store.commit('login', userData);
      } else {
        this.$store.commit('register', userData);
      }
      
      this.username = '';
      this.password = '';
    },
  },
};
</script>

<style scoped>
.auth-form-container {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 500px;
  padding: 40px 20px;
}

.auth-form-card {
  background: white;
  padding: 40px;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  max-width: 450px;
  width: 100%;
  animation: slideUp 0.5s ease-out;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.auth-header {
  text-align: center;
  margin-bottom: 32px;
}

.auth-header h2 {
  color: #2c3e50;
  margin: 0 0 8px 0;
  font-size: 2rem;
}

.auth-subtitle {
  color: #7f8c8d;
  margin: 0;
  font-size: 0.95rem;
}

.auth-form {
  margin-bottom: 24px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-weight: 600;
  color: #2c3e50;
  font-size: 0.95rem;
}

.label-icon {
  font-size: 1.1rem;
}

.form-group input {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e9ecef;
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s;
}

.form-group input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.form-group input::placeholder {
  color: #95a5a6;
}

.btn-submit {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  color: white;
}

.btn-login {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.btn-login:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

.btn-register {
  background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
}

.btn-register:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(39, 174, 96, 0.4);
}

.auth-toggle {
  text-align: center;
  padding-top: 24px;
  border-top: 1px solid #e9ecef;
}

.auth-toggle p {
  margin: 0 0 12px 0;
  color: #7f8c8d;
  font-size: 0.9rem;
}

.toggle-button {
  background: none;
  border: none;
  color: #667eea;
  cursor: pointer;
  font-size: 1rem;
  font-weight: 600;
  text-decoration: underline;
  transition: color 0.2s;
}

.toggle-button:hover {
  color: #764ba2;
}

@media (max-width: 640px) {
  .auth-form-card {
    padding: 32px 24px;
  }
  
  .auth-header h2 {
    font-size: 1.6rem;
  }
}
</style>
