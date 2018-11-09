from django.http import JsonResponse
from rest_framework.views import APIView
from schedule.models import Schedule
from user.models import User
from schedule.serializer import ScheduleSerializer
from carpool.response_template import ResponseTemplate
from notification.send_email import send_email_to_waiter, send_email_to_rider
from google_api.google_map import get_distance_time_by_locations
import json


def get_object(uid):
    try:
        schedule = Schedule.objects.filter(user_id=uid, finished=0).order_by('id')
        return schedule
    except Schedule.DoesNotExist:
        return None


class ScheduleList(APIView):
    def post(self, request, format=None):
        print('API: /schedule/save.json\n' + json.dumps(request.data, indent=2))

        request.data['user'] = request.data['uid']
        del request.data['uid']
        schedule = get_object(request.data['user']).first()
        if schedule is None:
            serializer = ScheduleSerializer(data=request.data)
        else:
            serializer = ScheduleSerializer(schedule, data=request.data)

        if serializer.is_valid():
            serializer.save()
            try:
                send_email_to_rider(serializer.data['user'])
            except Exception as e:
                print(e)
            response = ResponseTemplate.get_success_response()
        else:
            response = ResponseTemplate.get_failure_response('Save schedule failed')
        return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})


class ScheduleDetail(APIView):
    def get(self, request, id, format=None):
        print('API: /schedule/<id>.json\n' + json.dumps(request.data, indent=2))

        schedule = get_object(id).first()
        if schedule is not None:
            serializer = ScheduleSerializer(schedule)
            response = ResponseTemplate.get_success_response(serializer.data)
        else:
            response = ResponseTemplate.get_success_response([])
        return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})

    def put(self, request, format=None):
        print('API: /schedule/choose.json\n' + json.dumps(request.data, indent=2))
        request.data['user_id'] = request.data['id']

        schedule = get_object(request.data['id'])
        serializer = ScheduleSerializer(schedule, data=request.data)
        if serializer.is_valid():
            serializer.save()
            send_email_to_waiter(serializer.data['user_id'])
            response = ResponseTemplate.get_success_response()
        else:
            response = ResponseTemplate.get_failure_response('Save schedule failed')
        return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})


class BestMatch(APIView):
    def get(self, request, id, format=None):
        print('API: /bestmatch/<id>.json\n' + json.dumps(request.data, indent=2))

        try:
            owner_schedule = Schedule.objects.filter(user_id=id).first()
            owner_serializer = ScheduleSerializer(owner_schedule)

            rider_schedules = Schedule.objects.filter(dest=owner_serializer.data['dest'],
                                                      create_at__lte=owner_serializer.data['time_window'], accepted=-1, type=1)
            rider_serializer = ScheduleSerializer(rider_schedules, many=True)

            data = []
            for rider in rider_serializer.data:
                item = {}
                item['id'] = rider['user']
                user = User.objects.get(pk=rider['user'])
                item['first_name'] = user.first_name
                item['address'] = rider['origin']

                try:
                    item['distance'], item['time'] = get_distance_time_by_locations(owner_serializer.data['origin'], owner_serializer.data['dest'], rider['origin'])
                except Exception as e:
                    print(e)

                data.append(item)
            response = ResponseTemplate.get_success_response(data, len(data))
            return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})
        except Exception as e:
            print(e)
            response = ResponseTemplate.get_failure_response('Retrieve best match list failed')
            return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})
