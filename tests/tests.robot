*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   keywords/keywords_api_surveys.robot
Resource   keywords/keywords_faas.robot

*** Variables ***
${CONTEO}    ${3}
${MAX_REINTENTOS}    ${3}

# URLs BASE - Microservicios en puertos separados
${URL_SURVEYS}      http://localhost:8000/api    # Survey Service
${URL_ANSWERS}      http://localhost:8001/api    # Answer Service  
${URL_REPORTS}      http://localhost:8002/api        # Report Service (sin /api)
${URL_FAAS}         http://localhost:8003        # FaaS Export Function

# NOMBRES DE SESIONES
${SESION_SURVEYS}   surveys_session
${SESION_ANSWERS}   answers_session
${SESION_REPORTS}   reports_session
${SESION_FAAS}      faas_session

# DATOS PARA SURVEYS
&{DATOS_SURVEY}    name=Encuesta Para TEST    description=Descripción de la encuesta para pruebas
&{DATOS_SURVEY_UPDATE}    name=Encuesta Actualizada    description=Descripción actualizada de la encuesta para pruebas

# DATOS PARA QUESTIONS
&{DATOS_QUESTION}    text=¿Te gusta programar?    question_type=Cerrada
&{DATOS_QUESTION_UPDATE}    text=¿Te gusta mucho programar?    question_type=Cerrada
&{DATOS_QUESTION_ABIERTA}    text=¿Qué opinas sobre programar?    question_type=Abierta

# DATOS PARA OPTIONS
&{DATOS_OPTION_SI}    text=Si
&{DATOS_OPTION_NO}    text=No
&{DATOS_OPTION_UPDATE}    text=Muchísimo

# DATOS PARA ANSWERS
&{DATOS_ANSWER_CERRADA}    id_question=1    id_option=1    answer=${None}
&{DATOS_ANSWER_ABIERTA}    id_question=1    id_option=${None}    answer=Me gusta mucho programar

*** Test Cases ***
Test Endpoint /Surveys/
    [Documentation]    Verificar todas las operaciones CRUD en el endpoint /surveys/
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test Surveys
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            
            # GET - Obtener todas las encuestas
            ${response}=    Obtener Surveys    ${SESION_SURVEYS}
            Validar Respuesta    ${response}    200
            
            # POST - Crear nueva encuesta
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            # GET - Obtener encuesta por ID
            ${response}=    Obtener Survey Por ID    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    200
            
            # PUT - Actualizar encuesta
            ${response}=    Actualizar Survey    ${SESION_SURVEYS}    ${survey_id}    ${DATOS_SURVEY_UPDATE}
            Validar Respuesta    ${response}    200
            
            # DELETE - Eliminar encuesta
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test Surveys exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test Surveys falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END

Test Endpoint /Questions/
    [Documentation]    Verificar todas las operaciones CRUD en el endpoint /questions/
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test Questions
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            
            # Crear encuesta primero para asociar preguntas
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            # Crear copias mutables de los datos y agregar survey_id
            ${question_data}=    Copy Dictionary    ${DATOS_QUESTION}
            Set To Dictionary    ${question_data}    survey=${survey_id}
            ${question_update_data}=    Copy Dictionary    ${DATOS_QUESTION_UPDATE}
            Set To Dictionary    ${question_update_data}    survey=${survey_id}
            
            # GET - Obtener todas las preguntas
            ${response}=    Obtener Questions    ${SESION_SURVEYS}
            Validar Respuesta    ${response}    200
            
            # POST - Crear nueva pregunta
            ${response}=    Crear Question    ${SESION_SURVEYS}    ${question_data}
            Validar Respuesta    ${response}    201
            ${question_id}=    Get From Dictionary    ${response.json()}    id
            
            # GET - Obtener pregunta por ID
            ${response}=    Obtener Question Por ID    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    200
            
            # PUT - Actualizar pregunta
            ${response}=    Actualizar Question    ${SESION_SURVEYS}    ${question_id}    ${question_update_data}
            Validar Respuesta    ${response}    200
            
            # DELETE - Eliminar pregunta
            ${response}=    Eliminar Question    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    204
            
            # Limpiar: eliminar encuesta
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test Questions exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test Questions falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END

Test Endpoint /Options/
    [Documentation]    Verificar todas las operaciones CRUD en el endpoint /options/
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test Options
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            
            # Crear encuesta y pregunta primero
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            ${question_data}=    Copy Dictionary    ${DATOS_QUESTION}
            Set To Dictionary    ${question_data}    survey=${survey_id}
            ${response}=    Crear Question    ${SESION_SURVEYS}    ${question_data}
            Validar Respuesta    ${response}    201
            ${question_id}=    Get From Dictionary    ${response.json()}    id
            
            # Crear copias mutables de los datos de opciones y agregar question_id
            ${option_data}=    Copy Dictionary    ${DATOS_OPTION_SI}
            Set To Dictionary    ${option_data}    question=${question_id}
            ${option_update_data}=    Copy Dictionary    ${DATOS_OPTION_UPDATE}
            Set To Dictionary    ${option_update_data}    question=${question_id}
            
            # GET - Obtener todas las opciones
            ${response}=    Obtener Options    ${SESION_SURVEYS}
            Validar Respuesta    ${response}    200
            
            # POST - Crear nueva opción
            ${response}=    Crear Option    ${SESION_SURVEYS}    ${option_data}
            Validar Respuesta    ${response}    201
            ${option_id}=    Get From Dictionary    ${response.json()}    id
            
            # GET - Obtener opción por ID
            ${response}=    Obtener Option Por ID    ${SESION_SURVEYS}    ${option_id}
            Validar Respuesta    ${response}    200
            
            # PUT - Actualizar opción
            ${response}=    Actualizar Option    ${SESION_SURVEYS}    ${option_id}    ${option_update_data}
            Validar Respuesta    ${response}    200
            
            # DELETE - Eliminar opción
            ${response}=    Eliminar Option    ${SESION_SURVEYS}    ${option_id}
            Validar Respuesta    ${response}    204
            
            # Limpiar: eliminar pregunta y encuesta
            ${response}=    Eliminar Question    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test Options exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test Options falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END

Test Endpoint /Answers/
    [Documentation]    Verificar creación de respuestas en el endpoint /answers/
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test Answers
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            Create Session    ${SESION_ANSWERS}    ${URL_ANSWERS}
            
            # Crear estructura completa para respuestas en el servicio de surveys
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            ${question_data}=    Copy Dictionary    ${DATOS_QUESTION}
            Set To Dictionary    ${question_data}    survey=${survey_id}
            ${response}=    Crear Question    ${SESION_SURVEYS}    ${question_data}
            Validar Respuesta    ${response}    201
            ${question_id}=    Get From Dictionary    ${response.json()}    id
            
            ${option_data}=    Copy Dictionary    ${DATOS_OPTION_SI}
            Set To Dictionary    ${option_data}    question=${question_id}
            ${response}=    Crear Option    ${SESION_SURVEYS}    ${option_data}
            Validar Respuesta    ${response}    201
            ${option_id}=    Get From Dictionary    ${response.json()}    id
            
            # POST - Crear respuesta cerrada en el servicio de answers
            ${answer_data}=    Copy Dictionary    ${DATOS_ANSWER_CERRADA}
            Set To Dictionary    ${answer_data}    id_question=${question_id}    id_option=${option_id}
            ${response}=    Crear Answer    ${SESION_ANSWERS}    ${answer_data}
            Validar Respuesta    ${response}    201
            
            # Limpiar datos en el servicio de surveys
            ${response}=    Eliminar Option    ${SESION_SURVEYS}    ${option_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Question    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test Answers exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test Answers falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END

Test Endpoint /Reports/
    [Documentation]    Verificar obtención de reportes en el endpoint /reports/
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test Reports
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            Create Session    ${SESION_ANSWERS}    ${URL_ANSWERS}
            Create Session    ${SESION_REPORTS}    ${URL_REPORTS}
            
            # Crear estructura completa para generar reporte
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            ${question_data}=    Copy Dictionary    ${DATOS_QUESTION}
            Set To Dictionary    ${question_data}    survey=${survey_id}
            ${response}=    Crear Question    ${SESION_SURVEYS}    ${question_data}
            Validar Respuesta    ${response}    201
            ${question_id}=    Get From Dictionary    ${response.json()}    id
            
            ${option_data}=    Copy Dictionary    ${DATOS_OPTION_SI}
            Set To Dictionary    ${option_data}    question=${question_id}
            ${response}=    Crear Option    ${SESION_SURVEYS}    ${option_data}
            Validar Respuesta    ${response}    201
            ${option_id}=    Get From Dictionary    ${response.json()}    id
            
            # Crear algunas respuestas en el servicio de answers
            ${answer_data}=    Copy Dictionary    ${DATOS_ANSWER_CERRADA}
            Set To Dictionary    ${answer_data}    id_question=${question_id}    id_option=${option_id}
            ${response}=    Crear Answer    ${SESION_ANSWERS}    ${answer_data}
            Validar Respuesta    ${response}    201
            
            # GET - Obtener reporte desde el servicio de reports
            ${response}=    Obtener Report    ${SESION_REPORTS}    ${survey_id}
            Validar Respuesta    ${response}    200
            
            # Limpiar datos
            ${response}=    Eliminar Option    ${SESION_SURVEYS}    ${option_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Question    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test Reports exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test Reports falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END

Test FaaS Export Function
    [Documentation]    Verificar la función FaaS de exportación a CSV
    FOR    ${intento}    IN RANGE    1    ${MAX_REINTENTOS + 1}
        TRY
            Log    Intento ${intento} de ${MAX_REINTENTOS} - Test FaaS Export
            Create Session    ${SESION_SURVEYS}    ${URL_SURVEYS}
            Create Session    ${SESION_ANSWERS}    ${URL_ANSWERS}
            Create Session    ${SESION_FAAS}    ${URL_FAAS}
            
            # Health check del servicio FaaS
            ${response}=    Health Check FaaS    ${SESION_FAAS}
            Validar Respuesta    ${response}    200
            
            # Crear estructura para exportar
            ${response}=    Crear Survey    ${SESION_SURVEYS}    ${DATOS_SURVEY}
            Validar Respuesta    ${response}    201
            ${survey_id}=    Get From Dictionary    ${response.json()}    id
            
            ${question_data}=    Copy Dictionary    ${DATOS_QUESTION}
            Set To Dictionary    ${question_data}    survey=${survey_id}
            ${response}=    Crear Question    ${SESION_SURVEYS}    ${question_data}
            Validar Respuesta    ${response}    201
            ${question_id}=    Get From Dictionary    ${response.json()}    id
            
            ${option_data}=    Copy Dictionary    ${DATOS_OPTION_SI}
            Set To Dictionary    ${option_data}    question=${question_id}
            ${response}=    Crear Option    ${SESION_SURVEYS}    ${option_data}
            Validar Respuesta    ${response}    201
            ${option_id}=    Get From Dictionary    ${response.json()}    id
            
            # Crear respuesta
            ${answer_data}=    Copy Dictionary    ${DATOS_ANSWER_CERRADA}
            Set To Dictionary    ${answer_data}    id_question=${question_id}    id_option=${option_id}
            ${response}=    Crear Answer    ${SESION_ANSWERS}    ${answer_data}
            Validar Respuesta    ${response}    201
            
            # Exportar a CSV
            ${response}=    Exportar Survey a CSV    ${SESION_FAAS}    ${survey_id}
            Validar Respuesta    ${response}    200
            
            # Verificar estado de exportación
            ${response}=    Verificar Estado Exportacion    ${SESION_FAAS}    ${survey_id}
            Validar Respuesta    ${response}    200
            
            # Limpiar datos
            ${response}=    Eliminar Option    ${SESION_SURVEYS}    ${option_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Question    ${SESION_SURVEYS}    ${question_id}
            Validar Respuesta    ${response}    204
            ${response}=    Eliminar Survey    ${SESION_SURVEYS}    ${survey_id}
            Validar Respuesta    ${response}    204
            
            Log    Test FaaS Export exitoso en intento ${intento}
            BREAK
            
        EXCEPT    AS    ${error}
            Log    Error en intento ${intento}: ${error}
            IF    ${intento} == ${MAX_REINTENTOS}
                Fail    Test FaaS Export falló después de ${MAX_REINTENTOS} intentos. Último error: ${error}
            END
            Sleep    2s
        END
    END
