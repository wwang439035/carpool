from rest_framework import serializers
from schedule.models import Schedule


class ScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Schedule
        fields = ('user', 'origin', 'origin_type', 'dest', 'dest_type', 'type', 'gender', 'time_window', 'accepted', 'finished')