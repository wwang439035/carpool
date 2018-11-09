from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from schedule import views


urlpatterns = [
    path('schedule/save/', views.ScheduleList.as_view()),
    path('schedule/<int:id>/', views.ScheduleDetail.as_view()),
    path('schedule/choose/', views.ScheduleDetail.as_view()),
    path('bestmatch/<int:id>/', views.BestMatch.as_view()),
]

urlpatterns = format_suffix_patterns(urlpatterns)