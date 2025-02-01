import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:dio/dio.dart';

import '../../utils/dynamic_base_url_Interceptor.dart';
import 'apiUrl.dart';

Future<String?>? _token = TokenManager().getAccessToken() != null
    ? TokenManager().getAccessToken()
    : null;

final Dio dio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    contentType: 'application/json; charset=utf-8',
    validateStatus: (status) => true,
  ),
)
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token = await TokenManager().getAccessToken(); // ✅ 비동기 처리
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
      return handler.next(options);
    },
  ))
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
