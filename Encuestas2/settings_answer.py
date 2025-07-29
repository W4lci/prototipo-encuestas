from .settings import *

# Configuración específica para el microservicio Answer
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "django_extensions",
    "Answer",  # SOLO Answer
]

# URLs específicas para Answer
ROOT_URLCONF = 'Encuestas2.urls_answer'
