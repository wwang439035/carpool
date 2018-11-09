from django.conf import settings
from http_utils.https_comm import get_https_data
from urllib import parse


def get_distance_time_by_locations(origin, dest, waypoints=None):
    values = {'origin': origin,
              'destination': dest,
              'waypoints': waypoints,
              'key': settings.GOOGLE_API_KEY}

    values = parse.urlencode(values)
    data = get_https_data(settings.GOOGLE_MAP_DIRECTION_URL + values)
    distance = data['routes'][0]['legs'][0]['distance']['text']
    time = data['routes'][0]['legs'][0]['duration']['text']
    return distance, time



