<!-- Footer.vue -->

<template>
    <footer class="footer">
      <div class="footer-content">
        <div class="footer-section">
          <h3>VMP Store</h3>
          <p>Tu tienda de confianza para vitaminas, minerales y proteínas</p>
        </div>
        
        <div class="footer-section">
          <h4>Contacto</h4>
          <p>📧 info@vmpstore.com</p>
          <p>📱 +1 (555) 123-4567</p>
        </div>
        
        <div class="footer-section">
          <h4>Síguenos</h4>
          <div class="social-links">
            <a href="#" aria-label="Facebook">📘</a>
            <a href="#" aria-label="Instagram">📷</a>
            <a href="#" aria-label="Twitter">🐦</a>
          </div>
        </div>
      </div>
      
      <div class="footer-bottom">
        <p>&copy; {{ currentYear }} VMP Store - Ever Cristian Conde Cala</p>
        <p class="footer-date">Última actualización: {{ currentDate }}</p>
      </div>
    </footer>
  </template>
  
  <script>
  export default {
    data() {
      return {
        currentYear: new Date().getFullYear(),
        currentDate: new Date().toLocaleDateString('es-ES', {
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        }),
      };
    },
  };
  </script>
  
  <style scoped>
  .footer {
    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
    color: #ecf0f1;
    padding: 40px 20px 20px;
    margin-top: 60px;
  }
  
  .footer-content {
    max-width: 1400px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 30px;
    margin-bottom: 30px;
  }
  
  .footer-section h3 {
    margin: 0 0 12px 0;
    font-size: 1.5rem;
    color: #3498db;
  }
  
  .footer-section h4 {
    margin: 0 0 12px 0;
    font-size: 1.1rem;
    color: #95a5a6;
  }
  
  .footer-section p {
    margin: 8px 0;
    opacity: 0.9;
    font-size: 0.95rem;
  }
  
  .social-links {
    display: flex;
    gap: 16px;
    margin-top: 12px;
  }
  
  .social-links a {
    font-size: 24px;
    text-decoration: none;
    transition: transform 0.2s;
  }
  
  .social-links a:hover {
    transform: scale(1.2);
  }
  
  .footer-bottom {
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    padding-top: 20px;
    text-align: center;
  }
  
  .footer-bottom p {
    margin: 4px 0;
    font-size: 0.9rem;
    opacity: 0.8;
  }
  
  .footer-date {
    font-size: 0.85rem;
    color: #95a5a6;
  }
  
  @media (max-width: 768px) {
    .footer-content {
      grid-template-columns: 1fr;
      text-align: center;
    }
    
    .social-links {
      justify-content: center;
    }
  }
  </style>
  