from rest_framework.views import APIView
from rest_framework.response import Response
from .models import Answer
from .serializers import AnswerSerializer
import requests
import json
## Aca solo debemos de enviar un get haciendo peticiones a las apis de las respuestas

class AnswerList(APIView):
    def get(self, request):
        # Para obtener TODOS los resultados de las encuestas:
        # Obtenemos el ID de la pregunta con la respuesta
        respuestas = Answer.objects.all()
        question_id = set(respuesta.id_question for respuesta in respuestas)

        nombres = {}
        preguntas = {}
        # Consultamos las encuestas
        for id in question_id:
            peticion = requests.get(f'http://192.168.219.1:8000/api/surveys/{id}/')
            if peticion.status_code == 200:
                encuesta_data = peticion.json()
                # Hacemos algo con los datos de la encuesta
                nombres[id] = encuesta_data["name"]
                preguntas[id] = json.dumps(encuesta_data["questions"])

                opciones = {}
        nombre_preguntas = {}
        for id in preguntas.keys():
            temporal = json.loads(preguntas.get(id))[0]
            # Crear un diccionario que mapee id de opción a texto
            opciones_dict = {}
            for opcion in temporal["options"]:
                opciones_dict[opcion["id"]] = opcion["text"]
            opciones[id] = opciones_dict
            nombre_preguntas[id] = temporal["text"]

        answers = {}
        for respuesta in respuestas:
            if respuesta.id_question not in answers:
                answers[respuesta.id_question] = []
            if respuesta.answer is not None:
                answers[respuesta.id_question].append(respuesta.answer)
            if respuesta.id_option is not None:
                question_options = opciones.get(respuesta.id_question, {})
                option_text = question_options.get(
                    respuesta.id_option, "Opción no encontrada"
                )
                answers[respuesta.id_question].append(option_text)

        # Organizamos los datos por encuesta
        encuestas_organizadas = {}
        for id_question in question_id:
            encuestas_organizadas[id_question] = {
            "nombre_encuesta": nombres.get(id_question, "Encuesta no encontrada"),
            "pregunta": nombre_preguntas.get(id_question, "Pregunta no encontrada"),
            "opciones": opciones.get(id_question, {}),
            "respuestas": answers.get(id_question, [])
            }

        return Response({
            "encuestas": encuestas_organizadas
        })


class AnswerDetail(APIView):
    def get(self, request, encuesta_id):
        # Obtener respuestas específicas de una encuesta
        respuestas = Answer.objects.filter(id_question=encuesta_id)
        
        if not respuestas:
            return Response({"error": "No se encontraron respuestas para esta encuesta"})
        
        # Consultar la encuesta específica
        peticion = requests.get(f'http://192.168.219.1:8000/api/surveys/{encuesta_id}/')
        if peticion.status_code != 200:
            return Response({"error": "Encuesta no encontrada"})
            
        encuesta_data = peticion.json()
        nombre_encuesta = encuesta_data["name"]
        pregunta_info = json.dumps(encuesta_data["questions"])
        
        # Procesar opciones y nombre de pregunta
        temporal = json.loads(pregunta_info)[0]
        opciones_dict = {}
        for opcion in temporal["options"]:
            opciones_dict[opcion["id"]] = opcion["text"]
        nombre_pregunta = temporal["text"]
        
        # Recopilar respuestas
        respuestas_lista = []
        for respuesta in respuestas:
            if respuesta.answer is not None:
                respuestas_lista.append(respuesta.answer)
            if respuesta.id_option is not None:
                option_text = opciones_dict.get(
                    respuesta.id_option, "Opción no encontrada"
                )
                respuestas_lista.append(option_text)
        
        return Response({
            "encuesta": {
                "nombre_encuesta": nombre_encuesta,
                "pregunta": nombre_pregunta,
                "opciones": opciones_dict,
                "respuestas": respuestas_lista
            }
        })