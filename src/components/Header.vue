<template>
    <header>
      <div class="header-content">
        <div class="logo">
          <img src="../assets/logo.png" alt="VMP Logo" />
          <span class="logo-text">VMP Store</span>
        </div>
        <div class="title">
          <h1>Vitaminas, Minerales y Proteínas</h1>
          <p class="subtitle">Tu salud es nuestra prioridad</p>
        </div>
        <div v-if="isLoggedIn" class="user-info">
          <span class="welcome-text">¡Hola, <strong>{{ user.username }}</strong>!</span>
          <button @click="logout" class="logout-btn">Cerrar Sesión</button>
        </div>
      </div>
    </header>
  </template>
  
  <script>
  export default {
    computed: {
      isLoggedIn() {
        return this.$store.state.isLoggedIn;
      },
      user() {
        return this.$store.state.user;
      },
    },
    methods: {
      logout() {
        this.$store.commit('logout');
      },
    },
  };
  </script>
  
  <style scoped>
  header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    padding: 20px 40px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }
  
  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1400px;
    margin: 0 auto;
    gap: 20px;
  }
  
  .logo {
    display: flex;
    align-items: center;
    gap: 12px;
  }
  
  .logo img {
    max-height: 60px;
    filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
  }
  
  .logo-text {
    font-size: 1.5rem;
    font-weight: 700;
    display: none;
  }
  
  .title {
    flex: 1;
    text-align: center;
  }
  
  .title h1 {
    font-size: 1.8rem;
    margin: 0;
    font-weight: 700;
  }
  
  .subtitle {
    font-size: 0.9rem;
    margin: 4px 0 0 0;
    opacity: 0.9;
  }
  
  .user-info {
    display: flex;
    align-items: center;
    gap: 12px;
  }
  
  .welcome-text {
    font-size: 0.95rem;
  }
  
  .logout-btn {
    background: rgba(255, 255, 255, 0.2);
    color: #fff;
    border: 2px solid white;
    padding: 8px 16px;
    cursor: pointer;
    border-radius: 20px;
    transition: all 0.3s;
    font-weight: 600;
    backdrop-filter: blur(10px);
  }
  
  .logout-btn:hover {
    background: white;
    color: #667eea;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  @media (max-width: 968px) {
    .header-content {
      flex-direction: column;
      text-align: center;
    }
    
    .title {
      order: -1;
    }
    
    .title h1 {
      font-size: 1.5rem;
    }
    
    .logo-text {
      display: inline;
    }
  }
  
  @media (max-width: 640px) {
    header {
      padding: 16px 20px;
    }
    
    .title h1 {
      font-size: 1.2rem;
    }
    
    .subtitle {
      font-size: 0.8rem;
    }
  }
  </style>
  