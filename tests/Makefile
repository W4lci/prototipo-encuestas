# Makefile para automatizar el testing del Sistema de Encuestas
# Uso: make test

.PHONY: test setup teardown clean install-deps

# Variables
PROJECT_ROOT = ..
RESULTS_DIR = results
TIMESTAMP = $(shell date +%Y-%m-%d_%H-%M-%S)
TEST_REPORT = $(RESULTS_DIR)/test_report_$(TIMESTAMP)

# Target principal: make test
test: install-deps setup run-tests

# Instalar dependencias de Robot Framework
install-deps:
	@echo "=== Verificando e instalando dependencias ==="
	@which python3 > /dev/null || (echo "Error: Python3 no está instalado" && exit 1)
	@robot --version > /dev/null 2>&1 || (echo "Instalando Robot Framework..." && sudo apt update && sudo apt install -y python3-pip python3-robotframework python3-requests) || (echo "Intentando con pip..." && pip3 install --user robotframework robotframework-requests)
	@echo "✓ Dependencias verificadas"

# Configurar el entorno (levantar contenedores)
setup:
	@echo "=== Iniciando servicios con Docker Compose ==="
	@cd $(PROJECT_ROOT) && docker-compose up -d
	@echo "=== Esperando que los servicios estén listos ==="
	@sleep 30

# Ejecutar la suite de tests y generar reportes
run-tests:
	@echo "=== Ejecutando Suite de Tests Robot Framework ==="
	@mkdir -p $(RESULTS_DIR)
	@robot --outputdir $(RESULTS_DIR) --output $(TEST_REPORT).xml --log $(TEST_REPORT).html --report $(TEST_REPORT)_report.html tests.robot
	@echo "=== Tests completados ==="
	@echo "=== Reportes generados en carpeta $(RESULTS_DIR) ==="

# Limpiar el entorno (detener contenedores)
teardown:
	@echo "=== Deteniendo servicios Docker ==="
	@cd $(PROJECT_ROOT) && docker-compose down

# Limpiar archivos de resultados
clean:
	@echo "=== Limpiando resultados anteriores ==="
	@rm -rf $(RESULTS_DIR)
	@mkdir -p $(RESULTS_DIR)

# Instalar solo las dependencias (manual)
install:
	@echo "=== Instalando dependencias de Robot Framework ==="
	@echo "Opción 1: Usando gestor de paquetes del sistema..."
	sudo apt update && sudo apt install -y python3-pip python3-robotframework python3-requests || echo "Falló instalación del sistema"
	@echo "Opción 2: Usando pip con --user..."
	pip3 install --user robotframework robotframework-requests || echo "Falló instalación con pip"
	@echo "✓ Instalación completada"
