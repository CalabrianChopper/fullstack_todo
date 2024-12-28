from django.urls import path
from . import views

urlpatterns = [
    path('todos/', views.get_all_todos, name='get_all_todos'),  # GET ALL
    path('todos/<int:id>/', views.get_todo, name='get_todo'),   # GET by ID
    path('todos/create/', views.create_todo, name='create_todo'),  # POST
    path('todos/update/<int:id>/', views.update_todo, name='update_todo'),  # PUT
    path('todos/delete/<int:id>/', views.delete_todo, name='delete_todo'),  # DELETE
]