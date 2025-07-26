from rest_framework import generics
from django.urls import path
from .views import ExportCsvFn

urlpatterns = [
    path('export/<int:id_survey>/', ExportCsvFn.as_view()),
]