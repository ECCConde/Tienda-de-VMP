# Script para preparar el proyecto antes del commit
# Ejecutar antes de hacer git push

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PREPARAR PROYECTO PARA VERCEL" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$projectPath = "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP"
Set-Location $projectPath

Write-Host "📋 Verificando archivos..." -ForegroundColor Yellow

# 1. Verificar si existen archivos _new que deban ser renombrados
$newFiles = Get-ChildItem -Path "src" -Filter "*_new.vue" -Recurse

if ($newFiles.Count -gt 0) {
    Write-Host "`n⚠️  Archivos *_new.vue encontrados:" -ForegroundColor Yellow
    foreach ($file in $newFiles) {
        Write-Host "   - $($file.FullName)" -ForegroundColor Gray
    }
    
    Write-Host "`n❌ IMPORTANTE: Debes ejecutar 'update-project.ps1' primero" -ForegroundColor Red
    Write-Host "   o renombrar manualmente los archivos antes de hacer commit.`n" -ForegroundColor Red
    
    $response = Read-Host "¿Deseas ejecutar update-project.ps1 ahora? (S/N)"
    if ($response -eq 'S' -or $response -eq 's') {
        .\update-project.ps1
    } else {
        Write-Host "`nAbortando. Por favor actualiza los archivos primero.`n" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ No se encontraron archivos pendientes de renombrar`n" -ForegroundColor Green
}

# 2. Verificar que existan los archivos principales
$requiredFiles = @(
    "src\App.vue",
    "src\components\Product.vue",
    "src\components\Cart.vue",
    "src\components\ProductList.vue",
    "src\components\Modal.vue",
    "src\components\Notification.vue"
)

$missing = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        $missing += $file
    }
}

if ($missing.Count -gt 0) {
    Write-Host "❌ Archivos faltantes:" -ForegroundColor Red
    foreach ($file in $missing) {
        Write-Host "   - $file" -ForegroundColor Gray
    }
    Write-Host "`nPor favor ejecuta 'update-project.ps1' primero.`n" -ForegroundColor Red
    exit 1
} else {
    Write-Host "✅ Todos los archivos principales existen`n" -ForegroundColor Green
}

# 3. Verificar vercel.json
if (Test-Path "vercel.json") {
    $vercelConfig = Get-Content "vercel.json" -Raw | ConvertFrom-Json
    if ($vercelConfig.nodeVersion -eq "24.x") {
        Write-Host "✅ vercel.json configurado correctamente (Node.js 24.x)`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  vercel.json existe pero Node.js no es 24.x`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ vercel.json no encontrado`n" -ForegroundColor Red
    exit 1
}

# 4. Mostrar estado de git
Write-Host "📊 Estado de Git:" -ForegroundColor Cyan
git status --short

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  RESUMEN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "✅ Proyecto listo para commit" -ForegroundColor Green
Write-Host "`n📝 Archivos de configuración Vercel:" -ForegroundColor Cyan
Write-Host "   - vercel.json (Node.js 24.x)" -ForegroundColor White
Write-Host "   - package.json (engines: Node >=24.x)" -ForegroundColor White
Write-Host "   - .nvmrc (24)" -ForegroundColor White
Write-Host "   - .node-version (24)" -ForegroundColor White

Write-Host "`n🚀 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. git add ." -ForegroundColor Yellow
Write-Host "   2. git commit -m `"fix: Configure Node.js 24.x for Vercel`"" -ForegroundColor Yellow
Write-Host "   3. git push origin master" -ForegroundColor Yellow

Write-Host "`n========================================`n" -ForegroundColor Cyan

$response = Read-Host "¿Deseas ejecutar estos comandos ahora? (S/N)"
if ($response -eq 'S' -or $response -eq 's') {
    Write-Host "`nEjecutando comandos git...`n" -ForegroundColor Cyan
    
    git add .
    
    Write-Host "`nArchivos agregados. Ingresa el mensaje del commit:" -ForegroundColor Yellow
    $commitMsg = Read-Host "Mensaje (presiona Enter para usar el predeterminado)"
    
    if ([string]::IsNullOrWhiteSpace($commitMsg)) {
        $commitMsg = "fix: Configure Node.js 24.x for Vercel deployment"
    }
    
    git commit -m $commitMsg
    
    Write-Host "`n¿Deseas hacer push ahora? (S/N)" -ForegroundColor Yellow
    $pushResponse = Read-Host
    
    if ($pushResponse -eq 'S' -or $pushResponse -eq 's') {
        git push origin master
        Write-Host "`n✅ ¡Push completado! Vercel iniciará el deployment automáticamente.`n" -ForegroundColor Green
        Write-Host "Ve a https://vercel.com para ver el progreso del deployment.`n" -ForegroundColor Cyan
    }
}

Write-Host "`nPresiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
