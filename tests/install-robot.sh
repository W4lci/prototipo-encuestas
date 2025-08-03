#!/bin/bash
# Script de instalación simple para Robot Framework
# Uso: ./install-robot.sh

echo "=== Instalando Robot Framework en Ubuntu/Debian ==="

# Actualizar repositorios
sudo apt update

# Instalar dependencias del sistema
sudo apt install -y python3-pip python3-venv

# Opción 1: Instalar desde repositorios del sistema (recomendado)
echo "Instalando desde repositorios del sistema..."
sudo apt install -y python3-robotframework python3-requests

# Verificar instalación
if command -v robot &> /dev/null; then
    echo "✓ Robot Framework instalado correctamente"
    robot --version
else
    echo "⚠ Instalación del sistema falló, probando con pip..."
    
    # Opción 2: Usar pip con --user
    pip3 install --user robotframework robotframework-requests
    
    # Agregar directorio local al PATH si no está
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    
    if command -v robot &> /dev/null; then
        echo "✓ Robot Framework instalado con pip --user"
        robot --version
    else
        echo "✗ Error: No se pudo instalar Robot Framework"
        exit 1
    fi
fi

echo "✅ Instalación completada. Ahora puedes ejecutar: make test"
