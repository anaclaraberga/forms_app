import 'package:dio/dio.dart';
import '../error/failures.dart';

class HttpClient {
  late final Dio _dio;

  HttpClient(String? baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? 'https://jsonplaceholder.typicode.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestBody: true,
        logPrint: (obj) => print('🌐 [HTTP] $obj'),
      ),
      InterceptorsWrapper(
        onError: (DioException error, handler) {
          return handler.next(error);
        },
      ),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      // if (e.type == DioExceptionType.connectionTimeout ||
      //     e.type == DioExceptionType.receiveTimeout) {
      //   throw NetworkFailure();
      // } else if (e.response != null) {
      //   throw ServerFailure(
      //     e.response?.statusMessage ?? 'Erro no servidor',
      //     statusCode: e.response?.statusCode,
      //   );
      // } else {
      //   throw ServerFailure('Erro desconhecido');
      // }

      throw _handleDioError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Falha na conexão com o servidor. Verifique sua internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            'Erro no servidor ($statusCode).';
        return ServerFailure(message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return ServerFailure('A requisição foi cancelada.');

      default:
        return ServerFailure('Ocorreu um erro inesperado.');
    }
  }
}
