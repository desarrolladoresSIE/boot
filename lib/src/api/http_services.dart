import 'package:dio/dio.dart';

class HttpServices {
  late Dio _dio;
  final String _token = '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';
  HttpServices() {
    _dio = Dio()
      ..options.headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
        'content-type': 'application/json',
      }
      ..options.baseUrl = 'https://api.openai.com/v1';
  }

  Future<Response> httpGet(String uri,
      {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(
      uri,
      queryParameters: queryParameters,
    );
    return response;
  }

  Future<Response> httpPost(
    String uri, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(uri, data: data, queryParameters: queryParameters);
    return response;
  }
}
