import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/provider/dio_provider.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<bool> login(String uid, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          'uid': uid,
          'password': password,
        },
        options: Options(
          contentType: Headers.jsonContentType, // JSON 데이터 전송
        ),
      );

      if (response.statusCode == 200) {
        print('로그인 성공 : ${response.data}');
        return true;
      } else {
        print('로그인 실패: ${response.data}');
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        // 서버 응답이 있는 경우
        print('서버 에러: ${e.response?.data}');
      } else {
        // 요청 자체가 실패한 경우
        print('요청 실패: $e');
      }
      return false;
    } catch (e) {
      print('예외 발생: $e');
      return false;
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});
