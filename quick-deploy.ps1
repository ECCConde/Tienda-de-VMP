# Quick Fix: Commit y Push para corregir vercel.json

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  FIX VERCEL.JSON - DEPLOYMENT" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$projectPath = "c:\Users\Ever\Desktop\progra2\Tienda-de-VMP"
Set-Location $projectPath

Write-Host "✅ vercel.json corregido (sin nodeVersion)" -ForegroundColor Green
Write-Host "✅ Node.js 24.x ya está configurado en Vercel Dashboard`n" -ForegroundColor Green

Write-Host "📝 Haciendo commit de la corrección...`n" -ForegroundColor Yellow

# Git commands
git add vercel.json SOLUCION_VERCEL.md

Write-Host "Archivos agregados:" -ForegroundColor Cyan
git status --short

Write-Host "`n🚀 Haciendo commit..." -ForegroundColor Yellow
git commit -m "fix: Remove invalid nodeVersion from vercel.json schema"

Write-Host "`n✅ Commit realizado!`n" -ForegroundColor Green

Write-Host "¿Deseas hacer PUSH ahora? (S/N): " -ForegroundColor Yellow -NoNewline
$response = Read-Host

if ($response -eq 'S' -or $response -eq 's') {
    Write-Host "`n🚀 Haciendo push a GitHub..." -ForegroundColor Cyan
    git push origin master
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  ✅ PUSH COMPLETADO" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    
    Write-Host "`n📊 Vercel iniciará el deployment automáticamente`n" -ForegroundColor Yellow
    Write-Host "Ve a: https://vercel.com/dashboard" -ForegroundColor Cyan
    Write-Host "Espera ~30-60 segundos`n" -ForegroundColor Gray
    
    Write-Host "✅ Deployment esperado:" -ForegroundColor Green
    Write-Host "   - Build: SUCCESSFUL" -ForegroundColor White
    Write-Host "   - Node.js: 24.x" -ForegroundColor White
    Write-Host "   - URL: https://tienda-de-vmp.vercel.app`n" -ForegroundColor White
} else {
    Write-Host "`n⏸️  Push cancelado." -ForegroundColor Yellow
    Write-Host "Cuando estés listo ejecuta: git push origin master`n" -ForegroundColor Gray
}

Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
