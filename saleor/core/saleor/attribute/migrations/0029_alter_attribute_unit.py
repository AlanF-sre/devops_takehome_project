# Generated by Django 3.2.19 on 2023-06-07 14:48

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("attribute", "0028_attribute_attribute_gin"),
    ]

    operations = [
        migrations.AlterField(
            model_name="attribute",
            name="unit",
            field=models.CharField(
                blank=True,
                choices=[
                    ("mm", "mm"),
                    ("cm", "cm"),
                    ("dm", "dm"),
                    ("m", "m"),
                    ("km", "km"),
                    ("ft", "ft"),
                    ("yd", "yd"),
                    ("inch", "inch"),
                    ("sq_mm", "sq_mm"),
                    ("sq_cm", "sq_cm"),
                    ("sq_dm", "sq_dm"),
                    ("sq_m", "sq_m"),
                    ("sq_km", "sq_km"),
                    ("sq_ft", "sq_ft"),
                    ("sq_yd", "sq_yd"),
                    ("sq_inch", "sq_inch"),
                    ("cubic_millimeter", "cubic_millimeter"),
                    ("cubic_centimeter", "cubic_centimeter"),
                    ("cubic_decimeter", "cubic_decimeter"),
                    ("cubic_meter", "cubic_meter"),
                    ("liter", "liter"),
                    ("cubic_foot", "cubic_foot"),
                    ("cubic_inch", "cubic_inch"),
                    ("cubic_yard", "cubic_yard"),
                    ("qt", "qt"),
                    ("pint", "pint"),
                    ("fl_oz", "fl_oz"),
                    ("acre_in", "acre_in"),
                    ("acre_ft", "acre_ft"),
                    ("g", "g"),
                    ("lb", "lb"),
                    ("oz", "oz"),
                    ("kg", "kg"),
                    ("tonne", "tonne"),
                ],
                max_length=100,
                null=True,
            ),
        ),
    ]
