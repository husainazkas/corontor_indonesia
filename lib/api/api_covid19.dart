import 'package:corontor_indonesia/api/dio_interceptor.dart';
import 'package:corontor_indonesia/model/covid_national.dart';
import 'package:corontor_indonesia/model/covid_province.dart';
import 'package:corontor_indonesia/model/data.dart';
import 'package:dio/dio.dart';

class ApiCovid19 {
  final Dio _dio = Dio();
  final String _server = 'https://api.kawalcorona.com';

  ApiCovid19() {
    _dio.options
      ..baseUrl = _server
      ..headers = {'Access-Control-Allow-Origin': '*'} // FIXME: This still error if run app on the web.
      ..contentType = Headers.formUrlEncodedContentType;

    _dio.interceptors.add(DioInterceptor());
  }

  Future<Data<CovidNational>> getNational() async {
    try {
      final response = await _dio.get('/indonesia');
      return Data((response.data as List)
          .map((e) => CovidNational.fromJson(e))
          .toList());
    } catch (e) {
      print(e);
      return Data.withError(e.toString());
    }
  }

  Future<Data<CovidProvince>> getProvince() async {
    try {
      final response = await _dio.get('/indonesia/provinsi');
      return Data((response.data as List)
          .map((e) => CovidProvince.fromJson(e))
          .toList());
    } catch (e) {
      print(e);
      return Data.withError(e.toString());
    }
  }
}
