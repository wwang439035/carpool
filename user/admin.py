from django.contrib import admin
from user.models import User, Preference, HistoryAddress

# Register your models here.
admin.site.register(User)
admin.site.register(Preference)
admin.site.register(HistoryAddress)
