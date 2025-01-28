import 'package:applus_market/data/model/data_responseDTO.dart';
import 'package:dio/dio.dart';

import '../../../_core/apiUrl.dart';
import '../../../_core/logger.dart';
import '../../model/auth/tokens.dart';
import '../../model/auth/user.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository({required this.dio});

  Future<Tokens> login(String uid, String password) async {
    try {
      // 로그인 API 요청
      final response = await dio.post(
        '$apiUrl/auth/login',
        data: {'uid': uid, 'password': password},
      );

      // 토큰 반환
      DataResponseDTO<Tokens> responseDTO =
          DataResponseDTO.fromJson(response.data, (data) {
        return Tokens.fromJson(data);
      });

      if (responseDTO.code == 1000) {
        logger.d('responseDTO ${responseDTO.message}');
        return responseDTO.data!;
      } else {
        throw Exception(responseDTO.message);
      }
    } catch (e) {
      print('Login API error: $e');
      rethrow; // 호출한 곳에서 예외 처리
    }
  }

  Future<void> apiInsertUser(User user) async {
    String url = '$apiUrl/auth/register'; // API URL
    try {
      final response = await dio.post(
        url,
        data: {
          "uid": user.uid,
          "password": user.password,
          "hp": user.hp,
          "name": user.name,
          "email": user.email,
          "nickName": user.nickName,
          "birthday": user.birthday?.toIso8601String(), // DateTime -> String 변환
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
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
}
