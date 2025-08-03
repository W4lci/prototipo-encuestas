# Script para ejecutar tests de Robot Framework
# Configuración de directorios
$TestsDir = "tests"
$ResultsDir = "tests/results"
$LogFile = "$ResultsDir/log.html"
$ReportFile = "$ResultsDir/report.html"
$OutputFile = "$ResultsDir/output.xml"

# Crear directorio de resultados si no existe
if (!(Test-Path $ResultsDir)) {
    New-Item -ItemType Directory -Path $ResultsDir -Force
    Write-Host "Directorio de resultados creado: $ResultsDir"
}

Write-Host "🔧 Configuración de microservicios:"
Write-Host "   - Survey Service: http://localhost:8000"
Write-Host "   - Answer Service: http://localhost:8001"
Write-Host "   - Report Service: http://localhost:8002"
Write-Host "   - FaaS Export: http://localhost:8003"
Write-Host ""

# Ejecutar tests de Robot Framework
Write-Host "Ejecutando tests de Robot Framework..."
Write-Host "Generando reportes en: $ResultsDir"

try {
    robot --outputdir $ResultsDir --log $LogFile --report $ReportFile --output $OutputFile $TestsDir/tests.robot
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Tests ejecutados exitosamente"
        Write-Host "📊 Reportes generados en: $ResultsDir"
        Write-Host "   - Log: $LogFile"
        Write-Host "   - Report: $ReportFile"
        Write-Host "   - Output: $OutputFile"
    } else {
        Write-Host "⚠️  Tests completados con errores. Revisa los reportes para más detalles."
    }
} catch {
    Write-Host "❌ Error ejecutando tests: $($_.Exception.Message)"
    exit 1
}

# Mostrar resumen de archivos generados
Write-Host "`n📁 Archivos generados:"
Get-ChildItem $ResultsDir | ForEach-Object {
    Write-Host "   - $($_.Name) ($(Get-Date $_.LastWriteTime -Format 'yyyy-MM-dd HH:mm:ss'))"
}
