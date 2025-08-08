from .settings import *

# Configuración específica para el microservicio Survey
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "django_extensions",
    "Survey",  # SOLO Survey
    "django_prometheus",  # Para métricas de Prometheus
]

# URLs específicas para Survey
ROOT_URLCONF = 'Encuestas2.urls_survey'
