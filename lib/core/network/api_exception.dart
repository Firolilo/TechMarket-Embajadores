import 'package:dio/dio.dart';

class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final bool isUnauthorized;
  final bool isForbidden;

  const ApiException({
    this.statusCode,
    required this.message,
    this.isUnauthorized = false,
    this.isForbidden = false,
  });

  factory ApiException.fromDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    final message = (responseData is Map && responseData.containsKey('message'))
        ? responseData['message'] as String
        : error.message ?? 'Error de conexión';

    return ApiException(
      statusCode: statusCode,
      message: message,
      isUnauthorized: statusCode == 401,
      isForbidden: statusCode == 403,
    );
  }

  bool get isNetworkError => statusCode == null;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
