from .settings import *

# Configuración específica para el microservicio Report
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "rest_framework",
    "django_extensions",
    "Report",  # SOLO Report
]

# URLs específicas para Report
ROOT_URLCONF = 'Encuestas2.urls_report'
