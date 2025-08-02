API REST Endpoints
==================

Survey Service (Servicio de Encuestas)
---------------------------------------

Gestión de Encuestas
~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/api/surveys/``
     - Obtener todas las encuestas
     - 200
   * - POST
     - ``/api/surveys/``
     - Crear nueva encuesta
     - 201
   * - GET
     - ``/api/surveys/{id}/``
     - Obtener encuesta por ID
     - 200
   * - PUT
     - ``/api/surveys/{id}/``
     - Actualizar encuesta completa
     - 200
   * - DELETE
     - ``/api/surveys/{id}/``
     - Eliminar encuesta
     - 204

**Ejemplo de Request POST**:

.. code-block:: json

   {
     "name": "Encuesta de Satisfacción",
     "description": "Encuesta para evaluar la satisfacción del cliente"
   }

**Ejemplo de Response**:

.. code-block:: json

   {
     "id": 1,
     "name": "Encuesta de Satisfacción",
     "description": "Encuesta para evaluar la satisfacción del cliente",
     "created_at": "2025-07-29T01:54:20.517969Z"
   }

Gestión de Preguntas
~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/api/questions/``
     - Obtener todas las preguntas
     - 200
   * - POST
     - ``/api/questions/``
     - Crear nueva pregunta
     - 201
   * - GET
     - ``/api/questions/{id}/``
     - Obtener pregunta por ID
     - 200
   * - PUT
     - ``/api/questions/{id}/``
     - Actualizar pregunta completa
     - 200
   * - DELETE
     - ``/api/questions/{id}/``
     - Eliminar pregunta
     - 204

**Ejemplo de Request POST**:

.. code-block:: json

   {
     "text": "¿Cómo calificarías nuestro servicio?",
     "question_type": "Cerrada",
     "survey": 1
   }

Gestión de Opciones
~~~~~~~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/api/options/``
     - Obtener todas las opciones
     - 200
   * - POST
     - ``/api/options/``
     - Crear nueva opción
     - 201
   * - GET
     - ``/api/options/{id}/``
     - Obtener opción por ID
     - 200
   * - PUT
     - ``/api/options/{id}/``
     - Actualizar opción completa
     - 200
   * - DELETE
     - ``/api/options/{id}/``
     - Eliminar opción
     - 204

**Ejemplo de Request POST**:

.. code-block:: json

   {
     "text": "Excelente",
     "question": 1
   }

Answer Service (Servicio de Respuestas)
----------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - POST
     - ``/api/answers/``
     - Crear nueva respuesta
     - 201

**Ejemplo para pregunta cerrada**:

.. code-block:: json

   {
     "id_question": 1,
     "id_option": 1,
     "answer": null
   }

**Ejemplo para pregunta abierta**:

.. code-block:: json

   {
     "id_question": 2,
     "id_option": null,
     "answer": "El servicio fue excelente, muy satisfecho"
   }

Report Service (Servicio de Reportes)
--------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/reports/{encuesta_id}/``
     - Obtener reporte de respuestas
     - 200

**Ejemplo de Response**:

.. code-block:: json

   {
     "encuesta": {
       "nombre_encuesta": "Encuesta de Satisfacción",
       "pregunta": "¿Cómo calificarías nuestro servicio?",
       "opciones": {
         "1": "Excelente",
         "2": "Bueno",
         "3": "Regular"
       },
       "respuestas": ["Excelente", "Bueno", "Excelente"]
     }
   }
