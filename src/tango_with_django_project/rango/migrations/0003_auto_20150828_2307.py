# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('rango', '0002_auto_20150828_2305'),
    ]

    operations = [
        migrations.RenameField(
            model_name='category',
            old_name='view',
            new_name='views',
        ),
    ]
