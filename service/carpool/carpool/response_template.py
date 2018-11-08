class ResponseTemplate:

    @staticmethod
    def get_success_response(data, count=None):
        response = {
            'success': True,
        }

        if count is not None:
            response['count'] = count

        if data is not None:
            response['data'] = data

        return response

    @staticmethod
    def get_failure_response(message):
        response = {
            'success': False,
            'message': message
        }
        return response
