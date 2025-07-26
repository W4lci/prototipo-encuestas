from .views import AnswerCreateView
from django.urls import path

urlpatterns = [
    path("answers/", AnswerCreateView.as_view()),
]

