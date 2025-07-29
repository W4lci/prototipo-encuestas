# Sistema de Encuestas - Actividad 10

## API REST Endpoints

### Servicio de Encuestas (Survey Service)

#### Gestión de Encuestas

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `GET` | `/api/surveys/` | Obtener todas las encuestas | - | `{"message": "aun no hay encuestas"}` | `200` |
| `POST` | `/api/surveys/` | Crear nueva encuesta | `{"name": "string", "description": "string"}` | `{"id": 1, "name": "encuesta", "description": "encuesta1", "created_at": "2025-07-29T01:54:20.517969Z"}` | `201` |
| `GET` | `/api/surveys/{id}/` | Obtener encuesta por ID | - | `{"id": 1, "questions": [], "name": "encuesta", "description": "encuesta1", "created_at": "2025-07-29T01:54:20.517969Z"}` | `200` |
| `PUT` | `/api/surveys/{id}/` | Actualizar encuesta completa | `{"name": "string", "description": "string"}` | `{"id": 1, "questions": [], "name": "encuesta2", "description": "encuesta actualizada", "created_at": "2025-07-29T01:54:20.517969Z"}` | `200` |
| `DELETE` | `/api/surveys/{id}/` | Eliminar encuesta | - | - | `204` |

#### Gestión de Preguntas

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `GET` | `/api/questions/` | Obtener todas las preguntas | - | `[{"id": 1, "options": [], "text": "¿Te gusta algo?", "question_type": "Cerrada", "created_at": "2025-07-29T02:12:06.607342Z", "survey": 2}]` | `200` |
| `POST` | `/api/questions/` | Crear nueva pregunta | `{"text": "string", "question_type": "Cerrada/Abierta", "survey": "id"}` | `{"id": 1, "text": "¿Te gusta algo?", "question_type": "Cerrada", "created_at": "2025-07-29T02:12:06.607342Z", "survey": 2}` | `201` |
| `GET` | `/api/questions/{id}/` | Obtener pregunta por ID | - | `{"id": 1, "options": [], "text": "¿Te gusta algo?", "question_type": "Cerrada", "created_at": "2025-07-29T02:12:06.607342Z", "survey": 2}` | `200` |
| `PUT` | `/api/questions/{id}/` | Actualizar pregunta completa | `{"text": "string", "question_type": "Cerrada/Abierta", "survey": "id"}` | `{"id":1, "options":[], "text":"¿Te gusta programar?", "question_type":"Cerrada", "created_at":"2025-07-29T02:12:06.607342Z", "survey":2}` | `200` |
| `DELETE` | `/api/questions/{id}/` | Eliminar pregunta | - | - | `204` |

#### Gestión de Opciones

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `GET` | `/api/options/` | Obtener todas las opciones | - | `[{"id":1, "text":"Si", "created_at":"2025-07-29T02:19:19.234621Z", "question":2}, {"id":2, "text":"No", "created_at":"2025-07-29T02:19:22.786445Z", "question":2}]` | `200` |
| `POST` | `/api/options/` | Crear nueva opción | `{"text": "string", "question": "id"}` | `{"id": 1, "text": "Si", "created_at": "2025-07-29T02:19:19.234621Z", "question": 2}` | `201` |
| `GET` | `/api/options/{id}/` | Obtener opción por ID | - | `{"id":1, "text":"Si", "created_at":"2025-07-29T02:19:19.234621Z", "question":2}` | `200` |
| `PUT` | `/api/options/{id}/` | Actualizar opción completa | `{"text": "string", "question": "id"}` | `{"id":1, "text":"Muchisimo", "created_at":"2025-07-29T02:19:19.234621Z", "question":2}` | `200` |
| `DELETE` | `/api/options/{id}/` | Eliminar opción | - | - | `204` |

---

### Servicio de Respuestas (Answer Service)

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `POST` | `/api/answers/` | Crear nueva respuesta | `{"id_question": 1, "id_option": 1, "answer": null}` **Nota:** Para preguntas cerradas usar `id_option`, para abiertas usar `answer` | `{"id": 1, "id_question": 1, "id_option": 1, "answer": null}` | `201` |

---

### Servicio de Reportes (Report Service)

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `GET` | `/reports/{encuesta_id}/` | Obtener reporte de respuestas | - | `{"encuesta": {"nombre_encuesta": "Survey1", "pregunta": "¿Te gusta programar?", "opciones": {"1": "Muchisimo", "2": "No"}, "respuestas": ["Muchisimo", "No", "Muchisimo"]}}` | `200` |

---

## Función FaaS (Function as a Service)

### ExportCsvFn

#### Configuración de la Función

| Propiedad | Valor |
|-----------|-------|
| **Nombre** | ExportCsvFn |
| **Lenguaje de la función**| Bash |
| **Herramientas**| CsvKit |
| **Lenguaje para el trigger** | Python (FastAPI) |
| **Trigger** | HTTP POST Request |
| **Directorio de salida** | `./exports/` |
| **Formato de archivo** | `encuesta_{survey_id}.csv` |

#### Descripción

Función serverless que permite exportar los datos de una encuesta específica a formato CSV. La función recibe el ID de una encuesta como parámetro y ejecuta un script bash que extrae los datos y genera un archivo CSV (utilizando csvkit) con las respuestas de la encuesta.

#### Endpoints de la Función

| Método | Endpoint | Descripción | Request Body | Response | Status |
|--------|----------|-------------|--------------|----------|--------|
| `GET` | `/` | Health check de la función | - | `{"status": "healthy"}` | `200` |
| `POST` | `/exports/{survey_id}` | Exportar encuesta a CSV | - | `{"status":"success","message":"CSV export completed for survey 2","file_path":"exports/encuesta_2.csv","survey_id":2}` | `200` |
| `GET` | `/exports/{survey_id}/status` | Verificar estado de exportación | - | `{"status": "exists", "survey_id": 2, "file_path": "exports/encuesta_2.csv", "file_size": 12}` | `200` |