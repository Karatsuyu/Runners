from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0002_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('deliveries', '0003_deliveryrequest_completed_at_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='deliveryrequest',
            name='admin_delivery_fee',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=10, null=True),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='approval_status',
            field=models.CharField(
                choices=[('PENDIENTE', 'Pendiente'), ('AUTORIZADO', 'Autorizado'), ('RECHAZADO', 'Rechazado')],
                default='PENDIENTE',
                max_length=20,
            ),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='approved_at',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='is_delivered',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='is_paid',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='order',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='delivery_requests', to='store.order'),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='paid_at',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='deliveryrequest',
            name='approved_by',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='approved_delivery_requests', to=settings.AUTH_USER_MODEL),
        ),
        migrations.CreateModel(
            name='DeliveryChatMessage',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('recipient_role', models.CharField(choices=[('CLIENTE', 'Cliente'), ('ADMIN', 'Administrador'), ('DOMICILIARIO', 'Domiciliario')], max_length=20)),
                ('message', models.TextField()),
                ('read_at', models.DateTimeField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('delivery_request', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='chat_messages', to='deliveries.deliveryrequest')),
                ('sender', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='sent_delivery_messages', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name': 'Mensaje de Chat de Domicilio',
                'ordering': ['created_at'],
                'db_table': 'deliveries_chat_messages',
            },
        ),
    ]
