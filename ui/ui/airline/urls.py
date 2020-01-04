from django.contrib import admin
from django.urls import include, path
from . import views
urlpatterns = [
    path('pas', views.pas, name='pas'),
    path('flight', views.flight, name='flight'),
    path('resultpas', views.resultpas, name='resultpas'),
    path('admin/', admin.site.urls),
]
