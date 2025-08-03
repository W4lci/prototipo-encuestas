Function as a Service (FaaS)
============================

ExportCSV Function
------------------

Descripción
~~~~~~~~~~~

Función serverless que permite exportar los datos de una encuesta específica a formato CSV. La función utiliza un script bash que extrae los datos y genera un archivo CSV utilizando csvkit.

Configuración
~~~~~~~~~~~~~

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Propiedad
     - Valor
   * - **Nombre**
     - ExportCsvFn
   * - **Lenguaje de la función**
     - Bash
   * - **Herramientas**
     - CsvKit
   * - **Lenguaje para el trigger**
     - Python (FastAPI)
   * - **Trigger**
     - HTTP POST Request
   * - **Directorio de salida**
     - ``./exports/``
   * - **Formato de archivo**
     - ``encuesta_{survey_id}.csv``

Endpoints
~~~~~~~~~

Health Check
^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/``
     - Health check de la función
     - 200

**Response**:

.. code-block:: json

   {
     "status": "healthy"
   }

Exportar a CSV
^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - POST
     - ``/exports/{survey_id}``
     - Exportar encuesta a CSV
     - 200

**Response exitoso**:

.. code-block:: json

   {
     "status": "success",
     "message": "CSV export completed for survey 2",
     "file_path": "exports/encuesta_2.csv",
     "survey_id": 2
   }

Verificar Estado
^^^^^^^^^^^^^^^^

.. list-table::
   :header-rows: 1
   :widths: 10 30 40 20

   * - Método
     - Endpoint
     - Descripción
     - Status
   * - GET
     - ``/exports/{survey_id}/status``
     - Verificar estado de exportación
     - 200

**Response cuando existe**:

.. code-block:: json

   {
     "status": "exists",
     "survey_id": 2,
     "file_path": "exports/encuesta_2.csv",
     "file_size": 1024
   }

**Response cuando no existe**:

.. code-block:: json

   {
     "status": "not_found",
     "survey_id": 2,
     "message": "CSV file not found for survey 2"
   }

Uso
~~~

1. **Exportar encuesta**:

.. code-block:: bash

   curl -X POST http://localhost:8004/exports/1

2. **Verificar estado**:

.. code-block:: bash

   curl -X GET http://localhost:8004/exports/1/status

3. **Health check**:

.. code-block:: bash

   curl -X GET http://localhost:8004/

.. note::
   Los archivos CSV se generan en el directorio ``./exports/`` con el formato ``encuesta_{survey_id}.csv``.
