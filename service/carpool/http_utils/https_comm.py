from urllib import request
import json


def get_https_data(url):
    response = request.urlopen(url)
    data = response.read()
    encoding = response.info().get_content_charset('utf-8')
    response_data = json.loads(data.decode(encoding))
    return response_data