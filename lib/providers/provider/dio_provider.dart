import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return _dioInstance;
});

final Dio _dioInstance = Dio(BaseOptions(
    baseUrl: 'http://192.168.219.116:8080',
    connectTimeout: const Duration(seconds: 5), //  연결시간초과
    receiveTimeout: const Duration(seconds: 3), // 응답 시간 초과
    validateStatus: (status) => true,
    headers: {
      'Content-type': 'application/json',
      // 필요한 경우 'Authorization' : Be.... 토큰 값
    }));
