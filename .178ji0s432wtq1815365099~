from ..forms import SubjectForm
from django.shortcuts import redirect, render
from django.views.generic import TemplateView
import json
# from django.core import serializers
from django.shortcuts import *
from django.http import HttpResponse, JsonResponse
from ..models import *
from django.utils import *
from django.core.serializers import serialize



class SignUpView(TemplateView):
    template_name = 'registration/signup.html'


def home(request):
    if request.user.is_authenticated:
        if request.user.is_teacher:
            return redirect('teachers:quiz_change_list')
        elif request.user.is_student:
            return redirect('students:quiz_list')
        else:
            return redirect('adminpages:adminpages_home')
    return render(request, 'classroom/home.html')



def addsubject(request):
    if request.method == 'POST':
        form = SubjectForm(request.POST)

        if form.is_valid():
            form.save()
            return redirect('teachers:quiz_change_list')
    else:
        form = SubjectForm()

    return render(request, 'classroom/teachers/subject_add_form.html', {'form': form})