from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contacts', '0002_remove_contact_availability'),
    ]

    operations = [
        migrations.AddField(
            model_name='contact',
            name='email',
            field=models.EmailField(blank=True, max_length=254),
        ),
        migrations.AddField(
            model_name='contact',
            name='image',
            field=models.ImageField(blank=True, null=True, upload_to='contacts/'),
        ),
    ]
