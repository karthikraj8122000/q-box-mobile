import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:qr_page/service/apiservice/config.dart';

class ApiService {
  final Dio dio = Dio();
  String? url;

  Uri _buildUri(String port, String service, String endpoint) {
    return Uri.parse('${AppConfig.URL}${AppConfig.HOST}:$port${AppConfig.API_PREFIX}$service/$endpoint');
  }

  Future<dynamic> get(String port, String service, String endpoint, Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        _buildUri(port, service, endpoint).toString(),
        queryParameters: params,
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to perform GET request');
    }
  }

  Future<dynamic> post(String port, String service, String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(
        _buildUri(port, service, endpoint).toString(),
        data: json.encode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to perform POST request');
    }
  }

  Future<dynamic> put(String port, String service, String endpoint, dynamic body) async {
    try {
      final response = await dio.put(
        _buildUri(port, service, endpoint).toString(),
        data: json.encode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to perform PUT request');
    }
  }

  Future<dynamic> delete(String port, String service, String endpoint) async {
    try {
      final response = await dio.delete(
        _buildUri(port, service, endpoint).toString(),
      );

      return response.data;
    } catch (e) {
      throw Exception('Failed to perform DELETE request');
    }
  }

// Add more methods as needed, such as PATCH, HEAD, etc.
}