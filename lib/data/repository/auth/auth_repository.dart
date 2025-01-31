import 'package:applus_market/data/model/data_responseDTO.dart';
import 'package:applus_market/utils/dynamic_base_url_Interceptor.dart';
import 'package:dio/dio.dart';

import '../../../_core/utils/apiUrl.dart';
import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';
import '../../model/auth/tokens.dart';
import '../../model/auth/user.dart';

class AuthRepository {
  AuthRepository();

  Future<(Map<String, dynamic>, String)> login(
      String uid, String password) async {
    try {
      // 로그인 API 요청
      Response response = await dio.post(
        '/auth/login',
        data: {'uid': uid, 'password': password},
      );

      // 토큰 반환
      logger.e('response Header ${response.headers}');
      String? accessToken = response.headers.value('Authorization');

      // logger.i('jwt 토큰 확인 : ${response.headers['Authorization']?[0]}');
      accessToken = response.headers['Authorization']![0];
      Map<String, dynamic> responseBody = response.data;

      logger.i('Login User 정보확인 : ${responseBody}');

      if (responseBody['code'] == 1000) {}

      return (responseBody, accessToken);
    } catch (e) {
      rethrow; // 호출한 곳에서 예외 처리
    }
  }

  Future<void> apiInsertUser(Map<String, dynamic> reqData) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: reqData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User successfully inserted: ${response.data}");
      } else {
        print("Failed to insert user: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred while inserting user: $e");
    }
  }

  Future<void> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post('/auth/refresh',
          data: refreshToken,
          options: Options(
              headers: {'Cookie': 'refreshToken=${refreshToken}'},
              followRedirects: false));
    } catch (e) {
      logger.e(e);
    }
  }
}
