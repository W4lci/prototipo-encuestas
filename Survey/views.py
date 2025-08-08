#Endpoints para realizar CRUD
from rest_framework import viewsets
from .models import Option, Question, Survey
from .serializers import OptionSerializer, QuestionSerializer, SurveySerializer
from rest_framework.response import Response


class SurveyViewSet(viewsets.ModelViewSet):
    queryset = Survey.objects.all()
    serializer_class = SurveySerializer
    
    def list(self, request):
        queryset = self.get_queryset()
        if not queryset.exists():
            return Response({"message": "aun no hay encuestas"})
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

class QuestionViewSet(viewsets.ModelViewSet):
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer

class OptionViewSet(viewsets.ModelViewSet):
    queryset = Option.objects.all()
    serializer_class = OptionSerializer

