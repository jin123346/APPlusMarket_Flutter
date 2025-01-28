import 'package:dio/dio.dart';

import '../utils/dynamic_base_url_Interceptor.dart';

final Dio dio = Dio()
  ..interceptors.add(DynamicBaseUrlInterceptor())
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
