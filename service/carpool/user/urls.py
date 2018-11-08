from django.urls import path
from user import views


urlpatterns = [
    path('users/', views.user_list),
    path('users/<int:pk>', views.user_details)
]