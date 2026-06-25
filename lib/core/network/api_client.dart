import 'package:dio/dio.dart';
import '../services/token_service.dart';
import 'api_exception.dart';

class ApiClient {
  late final Dio _dio;
  final TokenService _tokenService;

  ApiClient({
    required String baseUrl,
    required TokenService tokenService,
    Map<String, String>? defaultHeaders,
  }) : _tokenService = tokenService {
    final headers = <String, dynamic>{'Content-Type': 'application/json'};
    if (defaultHeaders != null) headers.addAll(defaultHeaders);
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: headers,
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Los endpoints admin (ganancias) resuelven identidad por X-User-Id;
          // los /me la resuelven por el JWT, así que el header es inocuo allí.
          final userId = await _tokenService.getUserId();
          if (userId != null && userId.isNotEmpty) {
            options.headers['X-User-Id'] = userId;
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenService.clearTokens();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    try {
      return await _dio.post<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) async {
    try {
      return await _dio.put<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response<T>> patch<T>(String path, {dynamic data}) async {
    try {
      return await _dio.patch<T>(path, data: data);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
