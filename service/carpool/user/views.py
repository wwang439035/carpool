from django.http import Http404, JsonResponse
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from user.models import User, Preference, HistoryAddress
from user.serializer import UserSerializer, PreferenceSerializer, HistoryAddressSerializer
from carpool.response_template import ResponseTemplate
from django.contrib.auth.hashers import make_password, check_password
import json


class UserList(APIView):
    def get(self, request, format=None):
        users = User.objects.all()
        serializer = UserSerializer(users, many=True)
        return JsonResponse(serializer.data, safe=False, json_dumps_params={'indent': 2})

    def post(self, request, format=None):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserDetail(APIView):
    def get_object(self, pk):
        try:
            user = User.objects.get(pk=pk)
        except User.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        user = self.get_object(pk)
        serializer = UserSerializer(user)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        user = self.get_object(pk)
        serializer = UserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        user = self.get_object(pk)
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class Registration(APIView):
    def post(self, request, format=None):
        if not hasattr(request.data, 'email'):
            request.data['email'] = request.data['user_id']

        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.validated_data['password'] = make_password(serializer.validated_data['password'])
            serializer.save()

            gender_type = getattr(request.data, 'gender_type', 'any')
            time_window = getattr(request.data, 'time_window', 600)

            Preference.objects.create(user_id=serializer.data['id'], gender_type=gender_type, time_window=time_window)

            data = {
                'id': serializer.data['id'],
                'user_id': serializer.data['user_id'],
                'first_name': serializer.data['first_name']
            }
            response = ResponseTemplate.get_success_response(data)
            return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})
        response = ResponseTemplate.get_failure_response('Registration failed')
        return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})


class Login(APIView):
    def post(self, request, format=None):
        print('API: /users/login.json\n' + json.dumps(request.data, indent=2))
        user_id = request.data['user_id']
        password = request.data['password']
        try:
            user = User.objects.get(user_id=user_id)
            serializer = UserSerializer(user)

            if check_password(password, serializer.data['password']):
                data = {
                    'id': serializer.data['id'],
                    'user_id': serializer.data['user_id'],
                    'first_name': serializer.data['first_name']
                }
                response = ResponseTemplate.get_success_response(data)
            else:
                response = ResponseTemplate.get_failure_response('Login failed')

            return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})
        except User.DoesNotExist:
            return JsonResponse(ResponseTemplate.get_failure_response('Login failed'), safe=False, json_dumps_params={'indent': 2})


class AddressAutoSuggest(APIView):
    def get(self, request, pk, format=None):
        try:
            addresses = HistoryAddress.objects.filter(user_id=pk)
            serializer = HistoryAddressSerializer(addresses, many=True)

            data = []
            for address in serializer.data:
                data.append(address['address'])

            response = ResponseTemplate.get_success_response(data, len(data))
            return JsonResponse(response, safe=False, json_dumps_params={'indent': 2})
        except HistoryAddress.DoesNotExist:
            return JsonResponse(ResponseTemplate.get_success_response([]), safe=False, json_dumps_params={'indent': 2})



'''
@api_view(['GET', 'POST'])
def user_list(request, format=None):
    if request.method == 'GET':
        user = User.objects.all()
        serializer = UserSerializer(user, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def user_details(request, pk, format=None):
    try:
        user = User.objects.get(pk=pk)
    except User.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = UserSerializer(user)
        return Response(serializer.data, json_dumps_params={'indent': 2})

    elif request.method == 'PUT':
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
'''
