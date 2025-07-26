## Serializer para convertir los datos de Answer a JSON
from rest_framework import serializers
from .models import Answer

class AnswerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Answer
        fields = '__all__'  # Incluye todos los campos del modelo Answer
    
    def validate(self, data):
        if not data.get('id_question'):
            raise serializers.ValidationError("El campo 'id_question' es obligatorio.")
        if not data.get('answer') and not data.get('id_option'):
            raise serializers.ValidationError("Debe de usarse ya sea 'answer' o 'id_option'.")
        return data