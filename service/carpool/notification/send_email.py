from django.core.mail import send_mail
from django.conf import settings
from user.models import User


def send_email_to_rider(uid):
    subject = 'Thank you for using Carpool'
    message = 'The car will come soon.'

    user = User.objects.get(pk=uid)
    if user is not None:
        recipient_list = [user.email]
        send_email(subject, message, recipient_list)


def send_email_to_waiter(uid):
    subject = 'Thank you for using Carpool'
    message = 'Please wait for a while. Your request is in progress.'

    user = User.objects.get(pk=uid)
    if user is not None:
        recipient_list = [user.email]
        send_email(subject, message, recipient_list)


def send_email(subject, message, recipient_list):
    email_from = settings.EMAIL_HOST_USER
    send_mail(subject, message, email_from, recipient_list)
