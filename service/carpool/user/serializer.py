from rest_framework import serializers
from user.models import User, Preference, HistoryAddress


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'user_id', 'first_name', 'last_name', 'password', 'email', 'phone_number', 'gender')


class PreferenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Preference
        fields = ('user', 'gender_type', 'time_window')


class HistoryAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = HistoryAddress
        fields = ('user', 'address')


'''
class UserSerializer(serializers.Serializer):
    id = serializers.IntegerField(read_only=True)
    user_id = serializers.CharField()
    first_name = serializers.CharField(max_length=255)
    last_name = serializers.CharField(max_length=255)
    password = serializers.CharField()
    email = serializers.EmailField()
    phone_number = serializers.CharField()
    gender = serializers.CharField()

    def create(self, validated_data):
        return User.objects.create(**validated_data)

    def update(self, instance, validated_data):
        instance.user_id = validated_data.get('user_id', instance.user_id)
        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.last_name = validated_data.get('last_name', instance.last_name)
        instance.password = validated_data.get('password', instance.password)
        instance.email = validated_data.get('email', instance.email)
        instance.phone_number = validated_data.get('user_id', instance.phone_number)
        instance.gender = validated_data.get('gender', instance.gender)
        instance.save()
        return instance
'''
