Modelo de Datos Relacional vs. NoSQL y por qué se eligió MySQL
===============================================================

La estructura de una base de datos es un componente crucial en cualquier sistema
de información, ya que influye en la eficiencia, integridad y escalabilidad del
sistema. Al crear el Sistema de Encuestas basado en Microservicios con Django,
se analizaron dos enfoques principales para la gestión de datos: el modelo
relacional y el modelo NoSQL.

Comparación entre Modelo Relacional y NoSQL
-------------------------------------------

.. list-table:: Comparación de Modelos de Base de Datos
   :widths: 20 40 40
   :header-rows: 1

   * - Característica
     - Modelo Relacional (MySQL)
     - NoSQL (MongoDB, Cassandra, etc.)
   * - Estructura de datos
     - Tablas con relaciones definidas (SQL)
     - Documentos, grafos, pares clave-valor
   * - Esquema
     - Estricto y bien definido
     - Flexible, sin esquema rígido
   * - Consultas
     - Lenguaje estructurado (SQL)
     - Consultas específicas por tipo de NoSQL
   * - Integridad referencial
     - Alta (claves primarias/foráneas)
     - Limitada o inexistente
   * - Consistencia
     - Alta (ACID)
     - Eventual (BASE)
   * - Escalabilidad
     - Vertical por defecto
     - Horizontal (alta escalabilidad)
   * - Casos ideales
     - Sistemas con relaciones complejas
     - Big Data, datos semi/no estructurados

Justificación de Elección: ¿Por qué se eligió MySQL?
----------------------------------------------------

Dada la alta interconexión del sistema de datos, que incluye elementos como
encuestas, preguntas, respuestas y usuarios, se determinó que un modelo
relacional de base de datos era la opción más apropiada. A continuación, se
explican las razones específicas para elegir MySQL:

Relaciones bien establecidas
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cada encuesta se vincula a varias preguntas, y cada pregunta puede tener
múltiples respuestas. Este tipo de relaciones (1:N) uno a muchos y (N:1) muchos a
uno se administra más efectivamente mediante claves foráneas en una base de
datos relacional.

Mantenimiento de la integridad de los datos
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Es fundamental preservar la coherencia entre las encuestas, respuestas y
informes. MySQL permite establecer restricciones de integridad referencial que
evitan la inserción de datos huérfanos o no válidos.

Compatibilidad con Django
~~~~~~~~~~~~~~~~~~~~~~~~~

El framework de Django ofrece soporte natural y altamente optimizado para
sistemas de bases de datos relacionales, particularmente MySQL y PostgreSQL, lo
que simplifica la integración sin requerir librerías externas.

Experiencia y sencillez
~~~~~~~~~~~~~~~~~~~~~~~

MySQL es una tecnología consolidada, respaldada por una extensa
documentación y una sólida comunidad de soporte. Su rendimiento es adecuado
para la cantidad de transacciones previstas dentro del sistema de encuestas.

Capacidad suficiente de escalabilidad del sistema
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Aunque las bases de datos NoSQL se utilizan frecuentemente en sistemas
distribuidos con millones de registros, el volumen anticipado para este sistema se
sitúa en un rango que MySQL puede gestionar adecuadamente con la
optimización conveniente, sin sacrificar el rendimiento.

Conclusión Técnica
------------------

La elección de MySQL como base de datos relacional fue tomada de manera
fundamentada, priorizando la consistencia, la estructura relacional de los datos y
la integración fluida con Django y sus microservicios. Esta decisión permite al
sistema garantizar integridad de información, consultas eficientes y escalabilidad
vertical suficiente para su etapa de desarrollo y despliegue actual.