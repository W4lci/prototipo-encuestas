#!/bin/bash

# Script para simular carga de trabajo y monitorear en Grafana
# Requiere: wrk instalado (https://github.com/wg/wrk)

echo "En Windows usar WSL (si sirve)"

echo "Iniciando simulación de carga para monitoreo con Grafana"
echo "============================================================"


# Configuración
SURVEY_URL="http://localhost:8000/survey"
echo "Duración de la prueba en segundos:"
read DURATION
echo "Numero de Conexiones:"
read CONNECTIONS
echo "Numero de Threads:"
read THREADS

DURATION= "${DURATION}s"

echo "   Configuración de la prueba:"
echo "   URL: $SURVEY_URL"
echo "   Duración: $DURATION"
echo "   Conexiones concurrentes: $CONNECTIONS"
echo "   Threads: $THREADS"
echo ""

echo "   Abre Grafana en tu navegador:"
echo "   URL: http://localhost:3000"
echo "   Usuario: admin / Contraseña: admin"
echo "   Dashboard: Monitoreo"
echo ""

echo " Presiona Enter para iniciar la simulación..."
read -r

# Ejecutar wrk con parámetros optimizados para generar métricas visibles
echo " Ejecutando carga de trabajo..."
wrk -t$THREADS -c$CONNECTIONS -d$DURATION \
    $SURVEY_URL

echo ""
echo " Simulación completada!"
echo " Revisa los gráficos en Grafana para ver el impacto, y mira el correo de mailhog"
echo " En el localhost:8025 para ver la alerta"
