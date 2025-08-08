from django.urls import path, include
from rest_framework import routers
from .views import SurveyViewSet, QuestionViewSet, OptionViewSet

# Vamos a crear routers para usar los ViewsSets, asi no tenemos que crear manuealmente los endpoints
router = routers.DefaultRouter()
router.register(r'surveys', SurveyViewSet)
router.register(r'questions', QuestionViewSet)
router.register(r'options', OptionViewSet)

urlpatterns = [
    path('', include(router.urls)),
]