# Script de Actualización Automática para Tienda VMP
# Autor: Ever Cristian Conde Cala
# Fecha: 2026-04-05

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ACTUALIZACIÓN TIENDA VMP" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$basePath = "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP\src"

# Verificar que estamos en la ruta correcta
if (-not (Test-Path $basePath)) {
    Write-Host "❌ Error: No se encuentra el directorio del proyecto" -ForegroundColor Red
    Write-Host "   Ruta esperada: $basePath" -ForegroundColor Yellow
    exit 1
}

Set-Location $basePath

# Función para reemplazar archivos
function Update-ComponentFile {
    param(
        [string]$RelativePath,
        [string]$NewFileName
    )
    
    $oldPath = Join-Path $basePath $RelativePath
    $newPath = Join-Path $basePath $NewFileName
    
    if (Test-Path $newPath) {
        Write-Host "📝 Actualizando: $RelativePath" -ForegroundColor Yellow
        
        # Hacer backup del archivo original si existe
        if (Test-Path $oldPath) {
            $backupPath = "$oldPath.backup"
            Copy-Item $oldPath $backupPath -Force
            Write-Host "   └─ Backup creado: $backupPath" -ForegroundColor Gray
            Remove-Item $oldPath -Force
        }
        
        # Renombrar archivo nuevo
        Rename-Item $newPath -NewName (Split-Path $oldPath -Leaf) -Force
        Write-Host "   └─ ✅ Completado" -ForegroundColor Green
        return $true
    } else {
        Write-Host "⚠️  No encontrado: $NewFileName" -ForegroundColor Yellow
        return $false
    }
}

Write-Host "Iniciando actualización de archivos...`n" -ForegroundColor Cyan

$updated = 0
$total = 0

# Actualizar archivos principales
$files = @(
    @{Old="App.vue"; New="App_new.vue"},
    @{Old="components\Product.vue"; New="components\Product_new.vue"},
    @{Old="components\Cart.vue"; New="components\Cart_new.vue"},
    @{Old="components\ProductList.vue"; New="components\ProductList_new.vue"}
)

foreach ($file in $files) {
    $total++
    if (Update-ComponentFile $file.Old $file.New) {
        $updated++
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN DE ACTUALIZACIÓN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ Archivos actualizados: $updated/$total" -ForegroundColor Green

if ($updated -eq $total) {
    Write-Host "`n🎉 ¡Actualización completada exitosamente!" -ForegroundColor Green
    Write-Host "`n📋 Archivos nuevos ya disponibles:" -ForegroundColor Cyan
    Write-Host "   - src/components/Modal.vue" -ForegroundColor White
    Write-Host "   - src/components/Notification.vue" -ForegroundColor White
    
    Write-Host "`n📝 Archivos ya actualizados previamente:" -ForegroundColor Cyan
    Write-Host "   - src/store.js" -ForegroundColor White
    Write-Host "   - src/styles.css" -ForegroundColor White
    Write-Host "   - src/components/Header.vue" -ForegroundColor White
    Write-Host "   - src/components/Footer.vue" -ForegroundColor White
    Write-Host "   - src/components/AuthForm.vue" -ForegroundColor White
    Write-Host "   - package.json" -ForegroundColor White
    Write-Host "   - index.html" -ForegroundColor White
    Write-Host "   - README.md" -ForegroundColor White
    
    Write-Host "`n🚀 Próximos pasos:" -ForegroundColor Cyan
    Write-Host "   1. Ejecuta: npm install" -ForegroundColor Yellow
    Write-Host "   2. Ejecuta: npm run dev" -ForegroundColor Yellow
    Write-Host "   3. Abre: http://localhost:5173" -ForegroundColor Yellow
    
    Write-Host "`n💾 Nota: Se crearon archivos .backup por seguridad" -ForegroundColor Gray
} else {
    Write-Host "`n⚠️  Actualización parcial. Revisa los archivos faltantes." -ForegroundColor Yellow
}

Write-Host "`n========================================`n" -ForegroundColor Cyan

# Preguntar si desea ejecutar npm install
$response = Read-Host "¿Deseas ejecutar 'npm install' ahora? (S/N)"
if ($response -eq 'S' -or $response -eq 's') {
    Write-Host "`nEjecutando npm install..." -ForegroundColor Cyan
    Set-Location "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP"
    npm install
    
    Write-Host "`n✨ ¡Todo listo! Ejecuta 'npm run dev' para iniciar." -ForegroundColor Green
}

Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
