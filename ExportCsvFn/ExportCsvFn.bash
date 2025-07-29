
ID_ENCUESTA=$1
API_GET_RESULTADOS="http://reprts:8000/api/reports/$ID_ENCUESTA/"
DIRECCION="./exports"
CSV_FILE="$DIRECCION/encuesta_$ID_ENCUESTA.csv"

mkdir -p $DIRECCION

echo "Exportando los resultados de la encuesta con ID $ID_ENCUESTA a CSV..."

respuesta=$(curl -H "Content-Type: application/json" $API_GET_RESULTADOS)

echo "Respuesta de la API: $respuesta"
if [ -z "$respuesta" ]; then
    echo "No se encontraron resultados para la encuesta con ID $ID_ENCUESTA." >&2 #Tecnicamento esto hace raise de error
    exit 1
fi

# Convertir resultados a CSV con preguntas como filas y respuestas como columnas
if echo "$respuesta" | jq -e '.encuesta' > /dev/null 2>&1; then
    # Obtener todas las respuestas únicas de todas las preguntas para crear las columnas
    respuestas_unicas=$(echo "$respuesta" | jq -r '.encuesta.preguntas[].respuestas[]' | sort -u)
    
    # Crear encabezado
    echo -n "Pregunta" > "$CSV_FILE"
    while IFS= read -r respuesta_col; do
        echo -n ",\"$respuesta_col\"" >> "$CSV_FILE"
    done <<< "$respuestas_unicas"
    echo "" >> "$CSV_FILE"
    
    # Procesar cada pregunta
    echo "$respuesta" | jq -r '.encuesta.preguntas[] | .pregunta' | while IFS= read -r pregunta; do
        echo -n "\"$pregunta\"" >> "$CSV_FILE"
        
        while IFS= read -r respuesta_col; do
            count=$(echo "$respuesta" | jq -r --arg q "$pregunta" --arg r "$respuesta_col" '
                .encuesta.preguntas[] | 
                select(.pregunta == $q) | 
                .respuestas[] | 
                select(. == $r)
            ' | wc -l)
            echo -n ",$count" >> "$CSV_FILE"
        done <<< "$respuestas_unicas"
        echo "" >> "$CSV_FILE"
    done
else
    echo "Error: La respuesta no tiene el formato esperado."
    echo "Formato esperado: {\"encuesta\": {\"preguntas\": {...}}}"
    exit 1
fi

echo "Archivo CSV generado: $CSV_FILE"