from django.db import models

# Clases de la base de datos que utilizará el CRUD

class Answer(models.Model):
    id = models.AutoField(primary_key=True)
    id_question = models.IntegerField()
    id_option = models.IntegerField(null=True)
    answer = models.TextField(null = True)

    def __str__(self):
        return f"Answer {self.id} for Question {self.id_question}"

