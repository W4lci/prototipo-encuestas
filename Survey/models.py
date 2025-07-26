from django.db import models

# Clases que tiene Survey

class Survey(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Question(models.Model):
    class Choices(models.TextChoices):
        cerrada = "Cerrada", "Cerrada"
        abierta = "Abierta", "Abierta"

    id = models.AutoField(primary_key=True)
    survey = models.ForeignKey(Survey, related_name='questions', on_delete=models.CASCADE)
    text = models.CharField(max_length=255)
    question_type = models.CharField(max_length=10, choices=Choices.choices, default=Choices.cerrada)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.text

class Option(models.Model):
    id = models.AutoField(primary_key=True)
    question = models.ForeignKey(Question, related_name='options', on_delete=models.CASCADE)
    text = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.text
