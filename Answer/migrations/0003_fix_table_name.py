# Generated manually to fix table name
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ("Answer", "0002_alter_answer_answer"),
    ]

    operations = [
        migrations.RunSQL(
            "RENAME TABLE Answer_answer TO answer_answer;",
            reverse_sql="RENAME TABLE answer_answer TO Answer_answer;"
        ),
    ]
