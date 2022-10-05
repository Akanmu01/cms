from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils.html import escape, mark_safe
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
# from cloudinary.models import CloudinaryField
# from django.core.validators import FileExtensionValidator



class Notification(models.Model):
    date = models.DateField(auto_now_add = True)
    title = models.CharField(max_length = 255) 
    text = models.TextField()
    active = models.BooleanField(default = False)


class User(AbstractUser):
    is_student = models.BooleanField(default=False)
    is_teacher = models.BooleanField(default=False)
    is_admin = models.BooleanField(default=False)


# Model to store the list of logged in users
class LoggedInUser(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, related_name='logged_in_user', on_delete=models.CASCADE)
    # Session keys are 32 characters long
    session_key = models.CharField(max_length=32, null=True, blank=True)

    def __str__(self):
        return self.user.username


class Profile(models.Model):
    # picture = CloudinaryField(blank=False, validators=[FileExtensionValidator(allowed_extensions=['jpg', 'png', 'jpeg'])])
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    surname = models.CharField(max_length=200, blank=False)
    first_name = models.CharField(max_length=200, blank=False)
    other_name = models.CharField(max_length=200, blank=False)
    conference = models.CharField(max_length=200, blank=False)
    number = models.CharField(max_length=13, blank=False)

User.profile = property(lambda u:Profile.objects.get_or_create(user=u)[0])


STATUS = ((0, "Draft"), (1, "Publish"))

class TeacherRegistrationApproval(models.Model):
    teacher = models.CharField(max_length=10, default="Teacher")
    status = models.IntegerField(choices=STATUS, default=0)
    
    def __str__(self):
        return self.teacher

STATUS = ((0, "Draft"), (1, "Publish"))

class AdminPageApproval(models.Model):
    teacher = models.CharField(max_length=10, default="Teacher")
    status = models.IntegerField(choices=STATUS, default=0)
    
    def __str__(self):
        return self.teacher



class Subject(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    name = models.CharField(max_length=30)
    status = models.IntegerField(choices=STATUS, default=0)
    color = models.CharField(max_length=7, default='#007bff')

    def __str__(self):
        return self.name

    def get_html_badge(self):
        name = escape(self.name)
        color = escape(self.color)
        html = '<span class="badge badge-primary" style="background-color: %s">%s</span>' % (color, name)
        return mark_safe(html)


class Quiz(models.Model):
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='quizzes')
    name = models.CharField(max_length=255)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE, related_name='quizzes')
    status = models.IntegerField(choices=STATUS, default=0)

    def __str__(self):
        return self.name


class Question(models.Model):
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name='questions')
    text = models.CharField('Question', max_length=255)

    def __str__(self):
        return self.text


class Answer(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='answers')
    text = models.CharField('Answer', max_length=255, null=True, blank=True)
    is_correct = models.BooleanField('Correct answer', default=False)

    def __str__(self):
        return self.text


class Student(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    quizzes = models.ManyToManyField(Quiz, through='TakenQuiz')
    interests = models.ManyToManyField(Subject, related_name='interested_students')

    def get_unanswered_questions(self, quiz):
        answered_questions = self.quiz_answers \
            .filter(answer__question__quiz=quiz) \
            .values_list('answer__question__pk', flat=True)
        questions = quiz.questions.exclude(pk__in=answered_questions).order_by('text')
        return questions

    def __str__(self):
        return self.user.username


class TakenQuiz(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name='taken_quizzes')
    quiz = models.ForeignKey(Quiz, on_delete=models.CASCADE, related_name='taken_quizzes')
    score = models.FloatField()
    date = models.DateTimeField(auto_now_add=True)


class StudentAnswer(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name='quiz_answers')
    answer = models.ForeignKey(Answer, on_delete=models.CASCADE, related_name='+')
