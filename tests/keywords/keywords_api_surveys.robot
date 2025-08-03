*** Settings ***
Library    RequestsLibrary

*** Variables ***
${TIMEOUT}    30

*** Keywords ***
Validar Respuesta
    [Arguments]    ${response}    ${expected_status_code}
    [Documentation]    Valida que el código de estado de la respuesta sea el esperado
    Should Be Equal As Strings    ${response.status_code}    ${expected_status_code}
    Log    Validación de respuesta exitosa: ${response.status_code}

# ===== KEYWORDS PARA SURVEYS =====
Crear Survey
    [Arguments]    ${session}    ${survey_data}
    [Documentation]    Crea una nueva encuesta
    ${response}=    POST On Session    ${session}    /surveys/    json=${survey_data}
    RETURN    ${response}

Obtener Surveys
    [Arguments]    ${session}
    [Documentation]    Obtiene todas las encuestas
    ${response}=    GET On Session    ${session}    /surveys/
    RETURN    ${response}

Obtener Survey Por ID
    [Arguments]    ${session}    ${survey_id}
    [Documentation]    Obtiene una encuesta específica por ID
    ${response}=    GET On Session    ${session}    /surveys/${survey_id}/
    RETURN    ${response}

Actualizar Survey
    [Arguments]    ${session}    ${survey_id}    ${survey_data}
    [Documentation]    Actualiza una encuesta existente
    ${response}=    PUT On Session    ${session}    /surveys/${survey_id}/    json=${survey_data}
    RETURN    ${response}

Eliminar Survey
    [Arguments]    ${session}    ${survey_id}
    [Documentation]    Elimina una encuesta
    ${response}=    DELETE On Session    ${session}    /surveys/${survey_id}/
    RETURN    ${response}

# ===== KEYWORDS PARA QUESTIONS =====
Crear Question
    [Arguments]    ${session}    ${question_data}
    [Documentation]    Crea una nueva pregunta
    ${response}=    POST On Session    ${session}    /questions/    json=${question_data}
    RETURN    ${response}

Obtener Questions
    [Arguments]    ${session}
    [Documentation]    Obtiene todas las preguntas
    ${response}=    GET On Session    ${session}    /questions/
    RETURN    ${response}

Obtener Question Por ID
    [Arguments]    ${session}    ${question_id}
    [Documentation]    Obtiene una pregunta específica por ID
    ${response}=    GET On Session    ${session}    /questions/${question_id}/
    RETURN    ${response}

Actualizar Question
    [Arguments]    ${session}    ${question_id}    ${question_data}
    [Documentation]    Actualiza una pregunta existente
    ${response}=    PUT On Session    ${session}    /questions/${question_id}/    json=${question_data}
    RETURN    ${response}

Eliminar Question
    [Arguments]    ${session}    ${question_id}
    [Documentation]    Elimina una pregunta
    ${response}=    DELETE On Session    ${session}    /questions/${question_id}/
    RETURN    ${response}

# ===== KEYWORDS PARA OPTIONS =====
Crear Option
    [Arguments]    ${session}    ${option_data}
    [Documentation]    Crea una nueva opción
    ${response}=    POST On Session    ${session}    /options/    json=${option_data}
    RETURN    ${response}

Obtener Options
    [Arguments]    ${session}
    [Documentation]    Obtiene todas las opciones
    ${response}=    GET On Session    ${session}    /options/
    RETURN    ${response}

Obtener Option Por ID
    [Arguments]    ${session}    ${option_id}
    [Documentation]    Obtiene una opción específica por ID
    ${response}=    GET On Session    ${session}    /options/${option_id}/
    RETURN    ${response}

Actualizar Option
    [Arguments]    ${session}    ${option_id}    ${option_data}
    [Documentation]    Actualiza una opción existente
    ${response}=    PUT On Session    ${session}    /options/${option_id}/    json=${option_data}
    RETURN    ${response}

Eliminar Option
    [Arguments]    ${session}    ${option_id}
    [Documentation]    Elimina una opción
    ${response}=    DELETE On Session    ${session}    /options/${option_id}/
    RETURN    ${response}

# ===== KEYWORDS PARA ANSWERS =====
Crear Answer
    [Arguments]    ${session}    ${answer_data}
    [Documentation]    Crea una nueva respuesta
    ${response}=    POST On Session    ${session}    /answers/    json=${answer_data}
    RETURN    ${response}

# ===== KEYWORDS PARA REPORTS =====
Obtener Report
    [Arguments]    ${session}    ${survey_id}
    [Documentation]    Obtiene el reporte de una encuesta
    ${response}=    GET On Session    ${session}    /reports/${survey_id}/
    RETURN    ${response}