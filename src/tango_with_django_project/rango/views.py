from django.shortcuts import render
from django.http import HttpResponse
from django.core.urlresolvers import reverse


def index(request):
    uri = reverse('rango:about')
    return HttpResponse("Rango says Hi! <a href='" + uri + "'>About</a>")


def about(request):
    uri = reverse('rango:index')
    return HttpResponse("About page <a href='" + uri + "'>Home</a>")