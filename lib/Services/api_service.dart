import 'package:dio/dio.dart';
import '../Core/Configurations/config.dart';

class ApiService {
  final Dio _dio = Dio();
  final bool isLive;
  ApiService({this.isLive = true});

  Uri _makeUri(String port,String service,String endpoint,
      [Map<String, dynamic>? queryParams]) {
    final effectivePort = isLive ? '8000' : port;
    var uri = Uri.parse(
        '${AppConfig.url}${AppConfig.host}:$effectivePort${AppConfig.apiPrefix}$service/$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Future<dynamic> _handleResponse(Response response) async {
    if (response.statusCode == 200) {
      return Future.value(response.data);
    } else {
      throw Exception(
          'Request failed with status code : ${response.statusCode}');
    }
  }

  Future<dynamic> get(String port,String service, String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      final uri = _makeUri(port,service, endpoint,params);
      final response = await _dio.getUri(uri);
      return _handleResponse(response);
    } catch (error) {
      throw Exception("GET request failed:$error");
    }
  }

  Future<dynamic> post(
      String port,String service, String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = _makeUri(port,service, endpoint);
      final response = await _dio.postUri(uri,data: body);
      return _handleResponse(response);
    } catch (error) {
      throw Exception("POST request failed: $error");
    }
  }

  Future<dynamic> put(String port,String service, String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = _makeUri(port,service, endpoint);
      final response = await _dio.putUri(uri,data: body);
      return _handleResponse(response);
    } catch (error) {
      throw Exception("Put request failed: $error");
    }
  }

  Future<dynamic> delete(String port,String service, String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      final uri = _makeUri(port,service, endpoint,params);
      final response = await _dio.deleteUri(uri);
      return _handleResponse(response);
    } catch (error) {
      throw Exception("Delete request failed: $error");
    }
  }
}
