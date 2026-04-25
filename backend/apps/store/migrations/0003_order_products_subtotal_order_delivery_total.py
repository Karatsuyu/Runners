from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('store', '0002_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='order',
            name='delivery_total',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
        ),
        migrations.AddField(
            model_name='order',
            name='products_subtotal',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
        ),
    ]
