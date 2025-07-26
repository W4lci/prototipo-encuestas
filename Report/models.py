from django.db import models

# Create your models here.
class Answer(models.Model):
    id = models.AutoField(primary_key=True)
    id_question = models.IntegerField()
    id_option = models.IntegerField(null=True)
    answer = models.TextField(null=True)

    class Meta:
        db_table = 'answer_answer'

    def __str__(self):
        return f"Answer {self.id} for Question {self.id_question}"
