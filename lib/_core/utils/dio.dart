import 'package:dio/dio.dart';

import '../../utils/dynamic_base_url_Interceptor.dart';
import 'apiUrl.dart';

final Dio dio = Dio(
  BaseOptions(
    baseUrl: apiUrl,
    contentType: 'application/json; charset=utf-8',
    validateStatus: (status) => true,
  ),
)
  // ..interceptors.add(DynamicBaseUrlInterceptor())
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
