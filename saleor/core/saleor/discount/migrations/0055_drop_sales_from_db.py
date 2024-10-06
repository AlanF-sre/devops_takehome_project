# Generated by Django 3.2.22 on 2023-10-12 12:46

from django.db import migrations


class Migration(migrations.Migration):
    dependencies = [
        ("discount", "0054_drop_sales_models"),
    ]

    operations = [
        migrations.SeparateDatabaseAndState(
            database_operations=[
                migrations.RunSQL(
                    sql="""
                    DROP TABLE discount_sale_categories;
                    DROP TABLE discount_sale_collections;
                    DROP TABLE discount_sale_products;
                    DROP TABLE discount_sale_variants;
                    DROP TABLE discount_salechannellisting;
                    DROP TABLE discount_saletranslation;
                    DROP TABLE discount_sale;
                    """,
                    reverse_sql=migrations.RunSQL.noop,
                ),
            ]
        )
    ]
