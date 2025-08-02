Instalación y Configuración
============================

Requisitos Básicos
-------------------

* **Linux** (Ubuntu/Debian recomendado)
* **Ansible** instalado
* **Git**
* **Docker** y **Docker Compose** (para despliegue local)

Instalación
-----------

1. Clonar el Repositorio
~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   git clone https://github.com/W4lci/prototipo-encuestas.git

2. Despliegue Automático
~~~~~~~~~~~~~~~~~~~~~~~~

**Con Ansible (Recomendado para producción):**

.. code-block:: bash

   ansible-playbook one_deploy.yaml

.. note::
   Se necesita Linux obligatoriamente para el despliegue con Ansible.

3. Despliegue Local
~~~~~~~~~~~~~~~~~~~

**Con Docker Compose:**

.. code-block:: bash

   docker-compose up -d

Verificación
------------

Una vez desplegado, el sistema estará disponible en los siguientes puertos:

* **Survey Service**: Puerto 8001
* **Answer Service**: Puerto 8002  
* **Report Service**: Puerto 8003
* **ExportCSV Function**: Puerto 8004
