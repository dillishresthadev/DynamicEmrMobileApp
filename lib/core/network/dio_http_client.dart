import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class DioHttpClient {
  final Dio dio;

  DioHttpClient(this.dio) {
    // dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = {'Content-Type': 'application/json'};
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Map<String, String> _buildHeaders({
    String? token,
    String? contentType,
    Map<String, String>? customHeaders,
  }) {
    return {
      if (contentType != null) 'Content-Type': contentType,
      if (token != null) 'Authorization': 'Bearer $token',
      ...?customHeaders,
    };
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      log("GET Request: $endpoint, QueryParams: $queryParams");
      final response = await dio.get(
        endpoint,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(token: token, customHeaders: headers),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    dynamic body, // <-- can be Map or FormData
    String? token,
    Map<String, dynamic>? queryParams,
    String? contentType,
    Map<String, String>? headers,
  }) async {
    try {
      // Auto-detect multipart
      if (body is FormData) {
        contentType = 'multipart/form-data';
      } else {
        contentType ??= 'application/json';
      }

      if (body is FormData) {
        final formDataMap = {
          'fields': body.fields.map((f) => {f.key: f.value}).toList(),
          'files': body.files
              .map(
                (f) => {
                  'key': f.key,
                  'filename': f.value.filename,
                  'contentType': f.value.contentType.toString(),
                },
              )
              .toList(),
        };
        log(
          "POST Request: $endpoint, FormData: $formDataMap, QueryParams: $queryParams",
        );
      } else {
        log("POST Request: $endpoint, Body: $body, QueryParams: $queryParams");
      }
      final response = await dio.post(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(
            token: token,
            contentType: contentType,
            customHeaders: headers,
          ),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    List<int>? rawBody,
    String? contentType,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      log(
        "PUT Request: $endpoint, Body: ${rawBody ?? body}, QueryParams: $queryParams",
      );
      final response = await dio.put(
        endpoint,
        data: rawBody ?? body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(
            token: token,
            contentType: contentType,
            customHeaders: headers,
          ),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
    List<int>? rawBody,
    String? contentType,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      log(
        "PATCH Request: $endpoint, Body: ${rawBody ?? body}, QueryParams: $queryParams",
      );
      final response = await dio.patch(
        endpoint,
        data: rawBody ?? body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(
            token: token,
            contentType: contentType,
            customHeaders: headers,
          ),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    String? contentType,
    Map<String, String>? headers,
  }) async {
    try {
      log("DELETE Request: $endpoint, Body: $body, QueryParams: $queryParams");
      final response = await dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(
            token: token,
            contentType: contentType,
            customHeaders: headers,
          ),
        ),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is List<dynamic>) {
        return {"data": response.data};
      } else if (response.data is String) {
        try {
          return jsonDecode(response.data);
        } catch (e) {
          throw Exception("Invalid JSON format in response");
        }
      } else if (response.data is bool) {
        return {"data": response.data};
      } else if (response.data == null) {
        throw Exception("Response data is null");
      } else {
        throw Exception("Unexpected response data type");
      }
    } else {
      throw Exception("Unexpected status code");
    }
  }

  Map<String, dynamic> _handleError(DioException e) {
    if (e.response != null) {
      final errorMessage =
          e.response?.data?['message'] ?? 'An unknown error occurred';
      log("Extracted Error Message: $errorMessage");
      throw Exception(errorMessage);
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception('Connection timed out');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('No internet connection');
    }
    throw Exception("Network request failed");
  }
}
