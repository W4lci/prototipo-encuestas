from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Answer
from .serializers import AnswerSerializer
import requests
import json

class AnswerDetail(APIView):
    def get(self, request, encuesta_id):
        """
        Obtener reportes de respuestas para una encuesta específica por ID
        """
        try:
            # Consultar la encuesta específica
            peticion = requests.get(f'http://survey:8000/api/surveys/{encuesta_id}/')
            if peticion.status_code != 200:
                return Response({"error": "Encuesta no encontrada"}, status=404)
                
            encuesta_data = peticion.json()
            
            # Verificar si la respuesta es una lista o un objeto
            if isinstance(encuesta_data, list):
                if len(encuesta_data) == 0:
                    return Response({"error": "Encuesta no encontrada"}, status=404)
                survey_info = encuesta_data[0]  # Tomar el primer elemento si es lista
            else:
                survey_info = encuesta_data
            
            nombre_encuesta = survey_info["name"]
            preguntas = survey_info["questions"]
            
            # Procesar cada pregunta de la encuesta
            preguntas_con_respuestas = {}
            
            for pregunta in preguntas:
                pregunta_id = pregunta["id"]
                pregunta_texto = pregunta["text"]
                pregunta_tipo = pregunta["question_type"]
                opciones = pregunta.get("options", [])
                
                # Crear diccionario de opciones
                opciones_dict = {}
                for opcion in opciones:
                    opciones_dict[opcion["id"]] = opcion["text"]
                
                # Obtener respuestas para esta pregunta específica
                respuestas = Answer.objects.filter(id_question=pregunta_id)
                respuestas_lista = []
                
                for respuesta in respuestas:
                    if respuesta.answer is not None:
                        # Respuesta de texto libre
                        respuestas_lista.append(respuesta.answer)
                    elif respuesta.id_option is not None:
                        # Respuesta de opción múltiple
                        option_text = opciones_dict.get(
                            respuesta.id_option, f"Opción ID {respuesta.id_option} no encontrada"
                        )
                        respuestas_lista.append(option_text)
                
                # Agregar información de la pregunta
                preguntas_con_respuestas[pregunta_id] = {
                    "pregunta": pregunta_texto,
                    "tipo": pregunta_tipo,
                    "opciones": opciones_dict,
                    "respuestas": respuestas_lista,
                    "total_respuestas": len(respuestas_lista)
                }
            
            return Response({
                "encuesta": {
                    "id": encuesta_id,
                    "nombre": nombre_encuesta,
                    "preguntas": preguntas_con_respuestas
                }
            })
            
        except requests.RequestException:
            return Response({"error": "Error al conectar con el servicio de encuestas"}, status=503)
        except Exception as e:
            return Response({"error": f"Error interno: {str(e)}"}, status=500)