from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0001_initial'),
        ('contacts', '0003_contact_email_image'),
    ]

    operations = [
        migrations.AddField(
            model_name='contact',
            name='approval_status',
            field=models.CharField(
                choices=[('PENDIENTE', 'Pendiente'), ('APROBADO', 'Aprobado'), ('RECHAZADO', 'Rechazado')],
                default='APROBADO',
                max_length=20,
            ),
        ),
        migrations.AddField(
            model_name='contact',
            name='owner',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name='contacts',
                to='users.user',
            ),
        ),
        migrations.AddField(
            model_name='contact',
            name='rejection_reason',
            field=models.TextField(blank=True),
        ),
        migrations.AddField(
            model_name='contact',
            name='reviewed_at',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='contact',
            name='reviewed_by',
            field=models.ForeignKey(
                blank=True,
                null=True,
                on_delete=django.db.models.deletion.SET_NULL,
                related_name='reviewed_contacts',
                to='users.user',
            ),
        ),
    ]
