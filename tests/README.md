# Plan de Pruebas - Sistema de Encuestas

## Objetivos

Este plan de pruebas tiene como objetivo verificar que todos los microservicios del sistema de encuestas funcionen correctamente y se comuniquen entre si.

### Objetivos Principales:
- Probar que cada microservicio responda correctamente
- Verificar las operaciones CRUD en cada servicio
- Comprobar la integracion entre servicios
- Validar que la funcion FaaS de exportacion funcione
- Asegurar que el sistema sea resiliente con reintentos

## Arquitectura del Sistema

El sistema esta compuesto por 4 microservicios:

1. **Survey Service** (Puerto 8000) - Maneja encuestas, preguntas y opciones
2. **Answer Service** (Puerto 8001) - Maneja las respuestas de usuarios
3. **Report Service** (Puerto 8002) - Genera reportes de las encuestas
4. **FaaS Export** (Puerto 8003) - Funcion para exportar datos a CSV

## Tipos de Prueba

### 1. Pruebas Unitarias por Microservicio
- Cada servicio se prueba de forma independiente
- Se verifican todas las operaciones CRUD disponibles
- Se validan los codigos de respuesta HTTP

### 2. Pruebas de Integracion
- Se prueban las comunicaciones entre servicios
- Se verifica el flujo completo de datos
- Se valida la consistencia de la informacion

### 3. Pruebas de Resiliencia
- Cada prueba tiene 3 reintentos automaticos
- Se maneja la recuperacion ante fallos temporales
- Se registran los intentos y errores

## Matriz de Casos de Prueba

| Caso de Prueba | Servicio | Endpoint | Operacion | Resultado Esperado |
|----------------|----------|----------|-----------|-------------------|
| Test Surveys | Survey Service | /api/surveys/ | GET | Codigo 200, lista de encuestas |
| Test Surveys | Survey Service | /api/surveys/ | POST | Codigo 201, encuesta creada |
| Test Surveys | Survey Service | /api/surveys/{id}/ | GET | Codigo 200, encuesta especifica |
| Test Surveys | Survey Service | /api/surveys/{id}/ | PUT | Codigo 200, encuesta actualizada |
| Test Surveys | Survey Service | /api/surveys/{id}/ | DELETE | Codigo 204, encuesta eliminada |
| Test Questions | Survey Service | /api/questions/ | GET | Codigo 200, lista de preguntas |
| Test Questions | Survey Service | /api/questions/ | POST | Codigo 201, pregunta creada |
| Test Questions | Survey Service | /api/questions/{id}/ | GET | Codigo 200, pregunta especifica |
| Test Questions | Survey Service | /api/questions/{id}/ | PUT | Codigo 200, pregunta actualizada |
| Test Questions | Survey Service | /api/questions/{id}/ | DELETE | Codigo 204, pregunta eliminada |
| Test Options | Survey Service | /api/options/ | GET | Codigo 200, lista de opciones |
| Test Options | Survey Service | /api/options/ | POST | Codigo 201, opcion creada |
| Test Options | Survey Service | /api/options/{id}/ | GET | Codigo 200, opcion especifica |
| Test Options | Survey Service | /api/options/{id}/ | PUT | Codigo 200, opcion actualizada |
| Test Options | Survey Service | /api/options/{id}/ | DELETE | Codigo 204, opcion eliminada |
| Test Answers | Answer Service | /api/answers/ | POST | Codigo 201, respuesta creada |
| Test Reports | Report Service | /reports/{id}/ | GET | Codigo 200, reporte generado |
| Test FaaS Health | FaaS Export | / | GET | Codigo 200, servicio activo |
| Test FaaS Export | FaaS Export | /exports/{id} | POST | Codigo 200, exportacion iniciada |
| Test FaaS Status | FaaS Export | /exports/{id}/status | GET | Codigo 200, estado de exportacion |

## Configuracion de Pruebas

### Variables Importantes:
- `MAX_REINTENTOS`: 3 intentos por cada test
- Puertos de servicios: 8000, 8001, 8002, 8003
- Tiempo de espera entre reintentos: 2 segundos

### Datos de Prueba:
- Encuestas: "Encuesta Para TEST"
- Preguntas: "¿Te gusta programar?"
- Opciones: "Si", "No"
- Respuestas: Tanto cerradas como abiertas

## Como Ejecutar las Pruebas

1. Asegurate de que todos los servicios esten ejecutandose:
   ```
   docker-compose up -d
   ```

2. Ejecuta las pruebas con Robot Framework:
   ```
   robot --outputdir tests/results tests/tests.robot
   ```

3. Revisa los resultados en la carpeta `tests/results/`

## Resultados Esperados

- **6 casos de prueba** en total
- **Todos deben pasar** si los servicios funcionan correctamente
- **Reintentos automaticos** si hay fallos temporales
- **Logs detallados** de cada intento y resultado

## Notas Adicionales

- Las pruebas crean datos temporales que se eliminan automaticamente
- Cada test es independiente y no afecta a otros
- Si un servicio no responde, se reintenta hasta 3 veces
- Los resultados se guardan en formato HTML y XML

## Estructura de Archivos

```
tests/
├── tests.robot              # Archivo principal de pruebas
├── keywords/
│   ├── keywords_api_surveys.robot  # Keywords para Survey Service
│   └── keywords_faas.robot         # Keywords para FaaS Export
├── results/                 # Resultados de ejecucion
└── README.md               # Este archivo
```

---

**Nota**: Este plan de pruebas fue diseñado para validar la funcionalidad basica del sistema de encuestas y asegurar que todos los componentes trabajen correctamente en conjunto.