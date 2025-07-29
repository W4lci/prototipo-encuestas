# Sistema de Encuestas

Aplicación web de encuestas con microservioios

## Clonar Ejecutar Ver
### Requisitos Básicos

- **Linux** (Ubuntu/Debian recomendado)
- **Ansible** instalado
- **Git**

### 1. Clonar

```bash
git clone https://github.com/W4lci/prototipo-encuestas.git

```

### 2. Ejecutar

```bash
# Desplegar automáticamente con Ansible (Se necesita linux si o si, lo digo por experiencia)
ansible-playbook one_deploy.yaml

# O manualmente con Docker (para hacerlo local)
docker-compose up -d
```

### 3. Estructura más o menos es así, hay más archivos pero estas son las carpetas principales

```
Encuestas2/
├── Survey/         # Servicio de encuestas
├── Answer/         # Servicio de respuestas
├── Report/         # Servicio de reportes
├── ExportCsvFn/    # Contiene la FaaS, para el trigger está hecha en FastApi
└── docker-compose.yml
```
