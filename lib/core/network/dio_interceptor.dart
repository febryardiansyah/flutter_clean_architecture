import 'package:dio/dio.dart';

class DioInterceptor implements InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('Request: ${options.method} ${options.path}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    handler.next(options); // continue with the request
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Error: ${err.message}');
    print('Error Data: ${err.response?.data}');
    handler.next(err); // continue with the error
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('Response: ${response.statusCode} ${response.statusMessage}');
    print('Headers: ${response.headers}');
    print('Data: ${response.data}');
    handler.next(response); // continue with the response
  }
}
