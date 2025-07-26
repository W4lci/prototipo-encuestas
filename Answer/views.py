from .serializers import AnswerSerializer
from rest_framework import generics
from .models import Answer

# Crear respuestas 
class AnswerCreateView(generics.CreateAPIView):
    queryset = Answer.objects.all()
    serializer_class = AnswerSerializer