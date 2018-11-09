from django.db import models
from user.models import User
from django.utils.timezone import now


class Schedule(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, rel='user_id')
    origin = models.CharField(max_length=255)
    origin_type = models.IntegerField(default=0, blank=True)
    dest = models.CharField(max_length=255)
    dest_type = models.IntegerField(default=0, blank=True)
    type = models.IntegerField()
    time_window = models.DateTimeField()
    gender = models.CharField(max_length=255, default='any')
    accepted = models.IntegerField(default=-1, blank=True)
    finished = models.BooleanField(default=False, blank=True)
    create_at = models.DateTimeField(default=now, blank=True)
    update_at = models.DateTimeField(default=now, blank=True)

    class Meta:
        db_table = 'schedule'
