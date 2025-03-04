import 'dart:async';

import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../utils/dynamic_base_url_Interceptor.dart';
import 'apiUrl.dart';
import 'package:cookie_jar/cookie_jar.dart';

final cookieJar = CookieJar(); // ✅ 쿠키 저장소
Completer<void>? refreshCompleter; // 요청이 끝날때까지 기다리기

final Dio dio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    contentType: 'application/json; charset=utf-8',
    validateStatus: (status) => true,
  ),
)
  ..interceptors.add(CookieManager(cookieJar)) //  쿠키 관리 추가
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      String? token = TokenManager().getAccessToken(); //  비동기 처리
      if (token != null) {
        logger.d('여기에 또 셋팅되나?');
        options.headers["Authorization"] = "$token";
      }
      return handler.next(options);
    },
    onError: (error, handler) async {
      if (refreshCompleter == null) {
        refreshCompleter = Completer<void>();
        String? refreshToken = await TokenManager().getRefreshToken();
        if (refreshToken != null) {
          try {
            await SessionGVM().initializeAuthState();
            refreshCompleter?.complete();
            final cloneReq = await dio.fetch(error.requestOptions);
            return handler.resolve(cloneReq);
          } catch (e) {
            refreshCompleter?.completeError(e);
          } finally {
            refreshCompleter = null;
          }
        }
      }
      await refreshCompleter?.future;
      final cloneReq = await dio.fetch(error.requestOptions);
      return handler.resolve(cloneReq);
    },
  ))
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
