from django.urls import path
from .views import AnswerDetail

urlpatterns = [
    path('reports/<int:encuesta_id>/', AnswerDetail.as_view()),
]