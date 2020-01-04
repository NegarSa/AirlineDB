from django.shortcuts import render
from django.db import connection
# Create your views here.
from django.template import loader
from django.http import HttpResponse

def flight(request):
    cursor = connection.cursor()
    try:
        cursor.execute('EXEC forui')
        r = cursor.fetchall()

    finally:
        cursor.close()
    template = loader.get_template('flight.html')
    context = {
        'list': r,
    }
    return HttpResponse(template.render(context, request))


def pas(request):

    template = loader.get_template('pas.html')
    context = {

    }
    return HttpResponse(template.render(context, request))


def resultpas(request):
    cursor = connection.cursor()
    try:
        cursor.execute('EXEC forui2 ' + request.POST['ID'])
        r = cursor.fetchall()

    finally:
        cursor.close()
    template = loader.get_template('pv.html')
    context = {
        'list': r,
    }
    return HttpResponse(template.render(context, request))
