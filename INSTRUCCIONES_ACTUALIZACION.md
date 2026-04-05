# 📋 Instrucciones de Actualización

## Archivos Nuevos Creados (copiar manualmente)

Los siguientes archivos se han creado con el sufijo `_new` y necesitan reemplazar a los originales:

### 1. Componentes Nuevos
```
src/components/Product_new.vue     → src/components/Product.vue
src/components/Cart_new.vue        → src/components/Cart.vue  
src/components/ProductList_new.vue → src/components/ProductList.vue
src/App_new.vue                    → src/App.vue
```

### 2. Componentes Completamente Nuevos
Estos archivos son nuevos y ya están en su ubicación correcta:
- ✅ `src/components/Modal.vue`
- ✅ `src/components/Notification.vue`

### 3. Archivos Ya Actualizados
Estos archivos ya fueron modificados correctamente:
- ✅ `src/store.js` - Vuex mejorado con carrito y persistencia
- ✅ `src/styles.css` - Estilos globales mejorados
- ✅ `src/components/Header.vue` - Header rediseñado
- ✅ `src/components/Footer.vue` - Footer mejorado
- ✅ `src/components/AuthForm.vue` - Formulario renovado
- ✅ `package.json` - Nombre actualizado
- ✅ `index.html` - Título y favicon
- ✅ `README.md` - Documentación completa

## ⚡ Pasos para Aplicar Cambios

### Opción A: Copiar archivos manualmente (recomendado en Windows)

1. Eliminar archivos antiguos:
```powershell
cd "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP\src"
Remove-Item "App.vue"
Remove-Item "components\Product.vue"
Remove-Item "components\Cart.vue"
Remove-Item "components\ProductList.vue"
```

2. Renombrar archivos nuevos:
```powershell
Rename-Item "App_new.vue" -NewName "App.vue"
Rename-Item "components\Product_new.vue" -NewName "Product.vue"
Rename-Item "components\Cart_new.vue" -NewName "Cart.vue"
Rename-Item "components\ProductList_new.vue" -NewName "ProductList.vue"
```

### Opción B: Script PowerShell automático

Guarda este contenido en `update-files.ps1` y ejecútalo:

```powershell
$basePath = "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP\src"

# Función para reemplazar archivos
function Replace-File {
    param($old, $new)
    $oldPath = Join-Path $basePath $old
    $newPath = Join-Path $basePath $new
    
    if (Test-Path $newPath) {
        if (Test-Path $oldPath) {
            Remove-Item $oldPath -Force
        }
        Rename-Item $newPath -NewName (Split-Path $oldPath -Leaf)
        Write-Host "✅ Actualizado: $old" -ForegroundColor Green
    }
}

# Reemplazar archivos
Replace-File "App.vue" "App_new.vue"
Replace-File "components\Product.vue" "components\Product_new.vue"
Replace-File "components\Cart.vue" "components\Cart_new.vue"
Replace-File "components\ProductList.vue" "components\ProductList_new.vue"

Write-Host "`n✨ Actualización completada!" -ForegroundColor Cyan
```

## 🧪 Probar la Aplicación

Después de actualizar los archivos:

```bash
# Instalar dependencias (si no lo has hecho)
npm install

# Ejecutar en modo desarrollo
npm run dev

# El servidor se iniciará en http://localhost:5173
```

## ✅ Checklist de Funcionalidades

Prueba las siguientes funcionalidades:

### Autenticación
- [ ] Registrar un nuevo usuario
- [ ] Iniciar sesión
- [ ] Cerrar sesión
- [ ] Persistencia de sesión al recargar

### Productos
- [ ] Ver todos los productos
- [ ] Filtrar por categoría
- [ ] Ver indicadores de stock
- [ ] Ver productos con stock bajo
- [ ] Intentar comprar producto agotado

### Carrito
- [ ] Agregar producto al carrito
- [ ] Ver notificación de éxito
- [ ] Aumentar cantidad desde el carrito
- [ ] Disminuir cantidad desde el carrito
- [ ] Eliminar producto del carrito
- [ ] Ver total actualizado
- [ ] Vaciar carrito completo
- [ ] Cerrar carrito
- [ ] Verificar persistencia al recargar

### Compra Directa
- [ ] Hacer clic en "Comprar Ahora"
- [ ] Ver modal con detalles
- [ ] Cambiar cantidad
- [ ] Validar límite de stock
- [ ] Confirmar compra
- [ ] Ver notificación de éxito
- [ ] Verificar reducción de stock

### Checkout
- [ ] Agregar varios productos
- [ ] Finalizar compra desde carrito
- [ ] Ver modal de confirmación
- [ ] Confirmar compra
- [ ] Verificar carrito vacío
- [ ] Verificar stock actualizado

## 🐛 Solución de Problemas

### Error: "Cannot find module"
```bash
npm install
```

### Error en imports de componentes
Verifica que todos los archivos `_new` hayan sido renombrados correctamente.

### Carrito no persiste
Verifica que el plugin de localStorage en `store.js` esté configurado correctamente.

### Notificaciones no aparecen
Asegúrate de que `Notification.vue` esté importado en `App.vue`.

## 📊 Resumen de Cambios

- ✅ 11 archivos actualizados
- ✅ 2 archivos nuevos creados
- ✅ 4 archivos pendientes de renombrar
- ✅ Sistema de carrito completamente refactorizado
- ✅ UI/UX modernizada
- ✅ Persistencia implementada
- ✅ Validaciones mejoradas

¡Disfruta tu tienda renovada! 🎉
