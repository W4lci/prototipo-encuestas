Arquitectura del Sistema
========================

Descripción General
-------------------

El sistema implementa una arquitectura de microservicios con Django REST Framework, donde cada servicio maneja una responsabilidad específica.

Estructura del Proyecto
-----------------------

.. code-block:: text

   Encuestas2/
   ├── Survey/         # Servicio de encuestas
   ├── Answer/         # Servicio de respuestas
   ├── Report/         # Servicio de reportes
   ├── ExportCsvFn/    # Function as a Service (FaaS)
   └── docker-compose.yml

Microservicios
--------------

Survey Service (Servicio de Encuestas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsabilidad**: Gestión de encuestas, preguntas y opciones.

**Modelos principales**:

* **Survey**: Encuesta con nombre, descripción y fecha de creación
* **Question**: Pregunta asociada a una encuesta (tipo abierta o cerrada)
* **Option**: Opción de respuesta para preguntas cerradas

Answer Service (Servicio de Respuestas)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsabilidad**: Gestión de respuestas de usuarios a las encuestas.

**Modelos principales**:

* **Answer**: Respuesta que puede ser texto libre o selección de opción

Report Service (Servicio de Reportes)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsabilidad**: Generación de reportes y estadísticas de encuestas.

**Funcionalidad**:

* Obtiene datos de los otros servicios
* Genera reportes consolidados
* Proporciona estadísticas de respuestas

ExportCSV Function (Función FaaS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Responsabilidad**: Exportación de datos a formato CSV.

**Características**:

* Función serverless implementada con FastAPI
* Script bash para procesamiento con csvkit
* Almacenamiento en directorio ``./exports/``

Base de Datos
-------------

**Survey Service**: Base de datos ``Encuestas``
**Answer Service**: Base de datos ``Respuestas``
**Report Service**: Acceso a ambas bases de datos

.. note::
   Cada microservicio mantiene su propia base de datos siguiendo el patrón Database per Service.
