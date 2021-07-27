import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('--------------------------------------------------');
    print('Requesting...');
    print('Url: ' + options.baseUrl + options.path);
    print('Method: ' + options.method);
    print('Headers: ${options.headers}');
    print('--------------------------------------------------');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '${response.requestOptions.method} ${response.realUri}: ${response.statusCode} - Connected!');
    print('Receiving data...');
    print('Response: ${response.data}');
    print('--------------------------------------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('HTTP REQUEST ERROR: ${err.response?.statusCode ?? err.type}');
    print('${err.requestOptions.method} ${err.requestOptions.uri}');
    print('--------------------------------------------------');
    super.onError(err, handler);
  }
}
