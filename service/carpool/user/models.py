from django.db import models
from django.utils.timezone import now


class User(models.Model):
    user_id = models.CharField(max_length=255, unique=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    password = models.CharField(max_length=255)
    email = models.EmailField()
    phone_number = models.CharField(max_length=255)
    gender = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True, blank=True)
    updated_at = models.DateTimeField(default=now, blank=True)

    class Meta:
        db_table = 'user_profile'


class Preference(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    gender_type = models.CharField(max_length=255, default='any', blank=True)
    time_window = models.IntegerField(default=600, blank=True)

    class Meta:
        db_table = 'user_preference'


class HistoryAddress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, rel='user_id')
    address = models.CharField(max_length=255)

    class Meta:
        db_table = 'user_history_address'
