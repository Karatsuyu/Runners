# Generated migration for adding menu_pdf field to Commerce model

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0002_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='commerce',
            name='menu_pdf',
            field=models.FileField(blank=True, help_text='Carta o menú en PDF', null=True, upload_to='store/menus/'),
        ),
    ]
