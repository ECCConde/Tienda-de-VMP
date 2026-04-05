# 🚀 Script de Integración - VMP Store Frontend Moderno
# Este script verifica que todo esté listo para funcionar

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  VMP Store - Integración Completa" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que estamos en el directorio correcto
$projectPath = "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP"
if (!(Test-Path $projectPath)) {
    Write-Host "❌ Error: No se encuentra el proyecto en $projectPath" -ForegroundColor Red
    exit 1
}

Set-Location $projectPath
Write-Host "✅ Directorio del proyecto encontrado" -ForegroundColor Green
Write-Host ""

# Verificar archivos nuevos
Write-Host "📂 Verificando archivos creados..." -ForegroundColor Yellow
$newFiles = @(
    "src\design-system.css",
    "src\animations.css",
    "src\components\BaseButton.vue",
    "src\components\BaseInput.vue",
    "src\components\BaseCard.vue",
    "src\components\BaseBadge.vue",
    "src\components\ThemeToggle.vue",
    "src\components\Header_modern.vue",
    "src\components\ProductCard.vue",
    "src\components\ProductList_modern.vue"
)

$allFilesExist = $true
foreach ($file in $newFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file (FALTA)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (!$allFilesExist) {
    Write-Host ""
    Write-Host "❌ Faltan archivos. Por favor verifica la creación de componentes." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ Todos los archivos nuevos están presentes" -ForegroundColor Green
Write-Host ""

# Verificar node_modules
if (!(Test-Path "node_modules")) {
    Write-Host "📦 Instalando dependencias..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Error al instalar dependencias" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Dependencias instaladas" -ForegroundColor Green
} else {
    Write-Host "✅ Dependencias ya instaladas" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE INTEGRACIÓN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ COMPONENTES INTEGRADOS:" -ForegroundColor Green
Write-Host "  - Sistema de diseño (design-system.css)" -ForegroundColor White
Write-Host "  - Animaciones (animations.css)" -ForegroundColor White
Write-Host "  - 5 componentes base reutilizables" -ForegroundColor White
Write-Host "  - Header moderno con búsqueda y theme toggle" -ForegroundColor White
Write-Host "  - Product Cards 3D con efectos" -ForegroundColor White
Write-Host "  - ProductList con filtros avanzados" -ForegroundColor White
Write-Host ""
Write-Host "🎨 CARACTERÍSTICAS:" -ForegroundColor Green
Write-Host "  - Dark mode automático" -ForegroundColor White
Write-Host "  - Glassmorphism effects" -ForegroundColor White
Write-Host "  - Búsqueda instantánea" -ForegroundColor White
Write-Host "  - Filtros por categoría, precio, stock" -ForegroundColor White
Write-Host "  - Ordenamiento múltiple" -ForegroundColor White
Write-Host "  - Grid responsivo masonry" -ForegroundColor White
Write-Host "  - Vista rápida de productos" -ForegroundColor White
Write-Host "  - Sistema de favoritos" -ForegroundColor White
Write-Host ""
Write-Host "📱 RESPONSIVE:" -ForegroundColor Green
Write-Host "  - Mobile-first design" -ForegroundColor White
Write-Host "  - Hamburger menu" -ForegroundColor White
Write-Host "  - Sidebar colapsable" -ForegroundColor White
Write-Host "  - Touch-friendly" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 PARA INICIAR EL PROYECTO:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  npm run dev" -ForegroundColor Cyan
Write-Host ""
Write-Host "🌐 El proyecto se abrirá en:" -ForegroundColor Yellow
Write-Host "  http://localhost:5173" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 CARACTERÍSTICAS PARA PROBAR:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. 🌓 Theme Toggle - Click en el botón sol/luna" -ForegroundColor White
Write-Host "  2. 🔍 Búsqueda - Escribe en el campo de búsqueda" -ForegroundColor White
Write-Host "  3. 📂 Filtros - Usa categorías, precios, stock" -ForegroundColor White
Write-Host "  4. 🎴 Product Cards - Hover para ver efectos 3D" -ForegroundColor White
Write-Host "  5. ❤️ Favoritos - Click en el corazón de productos" -ForegroundColor White
Write-Host "  6. 👁️ Vista Rápida - Click en la imagen del producto" -ForegroundColor White
Write-Host "  7. 🛒 Carrito - Agrega productos y revisa el carrito" -ForegroundColor White
Write-Host "  8. 📱 Responsive - Reduce el tamaño de la ventana" -ForegroundColor White
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Preguntar si desea iniciar el servidor
$response = Read-Host "¿Deseas iniciar el servidor de desarrollo ahora? (s/n)"
if ($response -eq "s" -or $response -eq "S") {
    Write-Host ""
    Write-Host "🚀 Iniciando servidor de desarrollo..." -ForegroundColor Green
    Write-Host ""
    npm run dev
} else {
    Write-Host ""
    Write-Host "✅ Integración verificada. Ejecuta 'npm run dev' cuando estés listo." -ForegroundColor Green
    Write-Host ""
}
