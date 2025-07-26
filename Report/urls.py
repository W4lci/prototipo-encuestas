from django.urls import path
from .views import AnswerList, AnswerDetail

urlpatterns = [
    path('reports/', AnswerList.as_view()),
    path('reports/<int:encuesta_id>/', AnswerDetail.as_view()),
]