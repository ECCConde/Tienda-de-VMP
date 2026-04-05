# 🏪 Tienda Online De Vitaminas, Minerales y Suplementos Proteicos - **VMP Store**

Una moderna tienda en línea construida con Vue 3 y Vite, especializada en la venta de vitaminas, minerales y suplementos alimenticios.

## ✨ Características Principales

- 🔐 **Sistema de autenticación** con login y registro
- 🛒 **Carrito de compras inteligente** con persistencia en localStorage
- 📦 **15 productos** organizados en 3 categorías
- 🎯 **Gestión de stock en tiempo real**
- 🔔 **Notificaciones visuales** para feedback del usuario
- 📱 **Diseño responsive** adaptado a móviles y tablets
- 🎨 **Interfaz moderna** con gradientes y animaciones
- ⚡ **Compra directa o por carrito**
- 🔄 **Estado global** manejado con Vuex

## 🛠️ Stack Tecnológico

- **Frontend:** Vue 3 (Composition API y Options API)
- **Build Tool:** Vite
- **State Management:** Vuex 4
- **Persistencia:** localStorage
- **Estilos:** CSS3 con Flexbox y Grid
- **Iconos:** Emoji nativos

## 📦 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/Tienda-de-VMP.git

# Navegar al directorio
cd Tienda-de-VMP

# Instalar dependencias
npm install

# Iniciar servidor de desarrollo
npm run dev

# Construir para producción
npm run build

# Preview de producción
npm run preview
```

## 🚀 Demo en Vivo

Visita [https://tienda-de-vmp.pages.dev/](https://tienda-de-vmp.pages.dev/) para ver el proyecto en acción.

## 📂 Estructura del Proyecto

```
src/
├── components/
│   ├── Header.vue         # Cabecera con logo y usuario
│   ├── Footer.vue         # Pie de página con información
│   ├── AuthForm.vue       # Formulario login/registro
│   ├── ProductList.vue    # Lista de productos con filtros
│   ├── Product.vue        # Tarjeta individual de producto
│   ├── Cart.vue           # Carrito lateral deslizable
│   ├── Modal.vue          # Componente modal reutilizable
│   └── Notification.vue   # Sistema de notificaciones toast
├── assets/                # Imágenes de productos y logo
├── store.js              # Configuración de Vuex
├── styles.css            # Estilos globales
├── App.vue               # Componente raíz
└── main.js               # Punto de entrada
```

## 🎯 Funcionalidades Implementadas

### ✅ Autenticación
- Login y registro de usuarios
- Persistencia de sesión
- Validación de formularios
- Diseño atractivo y moderno

### ✅ Carrito de Compras
- Agregar/eliminar productos
- Aumentar/disminuir cantidades
- Validación de stock
- Cálculo automático de totales
- Persistencia en localStorage
- Animación de entrada lateral

### ✅ Gestión de Productos
- 15 productos en 3 categorías:
  - 🔸 Vitaminas (A, B12, C, D, E)
  - 🔹 Minerales (Calcio, Hierro, Magnesio, Zinc, Yodo)
  - 🟢 Suplementos (Proteína, Omega-3, Glutamina, Creatina, Fibra)
- Filtrado por categorías
- Indicadores de stock (disponible/bajo/agotado)
- Imágenes de producto
- Descripciones detalladas

### ✅ UX/UI
- Notificaciones toast (éxito, error, advertencia, info)
- Modales para confirmaciones
- Animaciones y transiciones suaves
- Diseño responsive
- Gradientes modernos
- Efectos hover

## 🔧 Mejoras Realizadas

### Bugs Corregidos
- ✅ Error CSS en Product.vue (max-width)
- ✅ Nombre del paquete actualizado
- ✅ Título y favicon configurados
- ✅ Validaciones de stock implementadas

### Nuevas Funcionalidades
- ✅ Migración de carrito a Vuex
- ✅ Persistencia con localStorage
- ✅ Sistema de notificaciones
- ✅ Componente Modal reutilizable
- ✅ Mejoras en el diseño
- ✅ Indicadores de stock
- ✅ Controles de cantidad en carrito

### Código Refactorizado
- ✅ Eliminación de código duplicado
- ✅ Mejora en estructura de componentes
- ✅ Estilos globales optimizados
- ✅ Validaciones robustas

## 📝 Próximas Mejoras

- [ ] Implementar Vue Router para navegación
- [ ] Conectar con backend (API REST)
- [ ] Sistema de favoritos
- [ ] Historial de compras
- [ ] Búsqueda de productos
- [ ] Filtros avanzados (precio, stock)
- [ ] Pasarela de pago
- [ ] Perfiles de usuario

## 👨‍💻 Autor

**Ever Cristian Conde Cala**

## 📄 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 🙏 Agradecimientos

- Imágenes de productos de marcas comerciales
- Inspiración de diseño de tiendas modernas de e-commerce
- Comunidad de Vue.js

---

⭐ Si te gusta este proyecto, ¡dale una estrella en GitHub!

