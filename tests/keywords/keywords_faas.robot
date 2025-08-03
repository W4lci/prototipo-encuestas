*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem

*** Variables ***
${FAAS_URL}    http://localhost:8003
${EXPORTS_DIR}    exports

*** Keywords ***
# ===== KEYWORDS PARA FUNCTION AS A SERVICE =====
Health Check FaaS
    [Arguments]    ${session}
    [Documentation]    Verifica que el servicio FaaS esté funcionando
    ${response}=    GET On Session    ${session}    /
    RETURN    ${response}

Exportar Survey a CSV
    [Arguments]    ${session}    ${survey_id}
    [Documentation]    Exporta una encuesta a formato CSV
    ${response}=    POST On Session    ${session}    /exports/${survey_id}
    RETURN    ${response}

Verificar Estado Exportacion
    [Arguments]    ${session}    ${survey_id}
    [Documentation]    Verifica el estado de una exportación CSV
    ${response}=    GET On Session    ${session}    /exports/${survey_id}/status
    RETURN    ${response}

Verificar Archivo CSV Existe
    [Arguments]    ${survey_id}
    [Documentation]    Verifica que el archivo CSV fue creado correctamente
    ${file_path}=    Set Variable    ${EXPORTS_DIR}/encuesta_${survey_id}.csv
    File Should Exist    ${file_path}
    RETURN    ${file_path}
