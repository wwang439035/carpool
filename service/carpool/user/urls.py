from django.urls import path
from rest_framework.urlpatterns import format_suffix_patterns
from user import views


urlpatterns = [
    path('users/', views.UserList.as_view()),
    path('users/<int:pk>/', views.UserDetail.as_view()),
    path('users/login/', views.Login.as_view()),
    path('users/reg/', views.Registration.as_view()),
    path('users/address/<int:pk>/', views.AddressAutoSuggest.as_view())
]

urlpatterns = format_suffix_patterns(urlpatterns)
