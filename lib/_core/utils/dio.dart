import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../utils/dynamic_base_url_Interceptor.dart';
import 'apiUrl.dart';
import 'package:cookie_jar/cookie_jar.dart';

final cookieJar = CookieJar(); // ✅ 쿠키 저장소

final Dio dio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    contentType: 'application/json; charset=utf-8',
    validateStatus: (status) => true,
  ),
)
  ..interceptors.add(CookieManager(cookieJar)) // ✅ 쿠키 관리 추가
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
