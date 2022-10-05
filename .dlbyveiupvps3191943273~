from django.contrib import admin
from .models import *



class QuizAdmin(admin.ModelAdmin):
	list_display = ("owner", "name", "subject")


admin.site.register(User)
admin.site.register(Notification)
admin.site.register(Subject)
admin.site.register(Quiz,QuizAdmin)
admin.site.register(Question)
admin.site.register(Answer)
admin.site.register(TakenQuiz)
admin.site.register(StudentAnswer)
admin.site.register(Profile)
admin.site.register(TeacherRegistrationApproval)