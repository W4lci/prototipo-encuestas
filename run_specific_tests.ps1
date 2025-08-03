# Script para ejecutar tests específicos de Robot Framework
param(
    [string]$TestName = "",
    [switch]$Help
)

if ($Help) {
    Write-Host "Uso: ./run_specific_tests.ps1 [-TestName <nombre>] [-Help]"
    Write-Host ""
    Write-Host "Parámetros:"
    Write-Host "  -TestName    Nombre específico del test a ejecutar"
    Write-Host "  -Help        Muestra esta ayuda"
    Write-Host ""
    Write-Host "Ejemplos:"
    Write-Host "  ./run_specific_tests.ps1 -TestName 'Test Endpoint /Surveys/'"
    Write-Host "  ./run_specific_tests.ps1 -TestName 'Test FaaS Export Function'"
    Write-Host ""
    Write-Host "Tests disponibles:"
    Write-Host "  - Test Endpoint /Surveys/"
    Write-Host "  - Test Endpoint /Questions/"
    Write-Host "  - Test Endpoint /Options/"
    Write-Host "  - Test Endpoint /Answers/"
    Write-Host "  - Test Endpoint /Reports/"
    Write-Host "  - Test FaaS Export Function"
    exit 0
}

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

# Construir comando de Robot Framework
$RobotCommand = "robot --outputdir $ResultsDir --log $LogFile --report $ReportFile --output $OutputFile"

if ($TestName -ne "") {
    $RobotCommand += " --test `"$TestName`""
    Write-Host "Ejecutando test específico: $TestName"
} else {
    Write-Host "Ejecutando todos los tests..."
}

$RobotCommand += " $TestsDir/tests.robot"

# Ejecutar tests
Write-Host "Comando: $RobotCommand"
Write-Host "Generando reportes en: $ResultsDir"

try {
    Invoke-Expression $RobotCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Tests ejecutados exitosamente"
    } else {
        Write-Host "⚠️  Tests completados con errores. Revisa los reportes para más detalles."
    }
    
    Write-Host "📊 Reportes generados en: $ResultsDir"
    Write-Host "   - Log: $LogFile"
    Write-Host "   - Report: $ReportFile"
    Write-Host "   - Output: $OutputFile"
} catch {
    Write-Host "❌ Error ejecutando tests: $($_.Exception.Message)"
    exit 1
}

# Mostrar resumen de archivos generados
Write-Host "`n📁 Archivos generados:"
Get-ChildItem $ResultsDir | ForEach-Object {
    Write-Host "   - $($_.Name) ($(Get-Date $_.LastWriteTime -Format 'yyyy-MM-dd HH:mm:ss'))"
}
