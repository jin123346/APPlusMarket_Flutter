import 'dart:io';

import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:applus_market/data/model/data_responseDTO.dart';
import 'package:applus_market/utils/dynamic_base_url_Interceptor.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../../../_core/utils/apiUrl.dart';
import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';
import '../../model/auth/tokens.dart';
import '../../model/auth/user.dart';

class AuthRepository {
  AuthRepository();

  // 로그인
  Future<(Map<String, dynamic>, String)> login(
      String uid, String password) async {
    // 로그인 API 요청
    String deviceInfo = await getDeviceInfo();

    Response response = await dio.post(
      '/auth/login',
      data: {'uid': uid, 'password': password, 'deviceInfo': deviceInfo},
    );
    // 토큰 반환
    logger.d('response Header ${response.headers}');
    String? accessToken = response.headers.value('Authorization');
    accessToken = response.headers['Authorization']?[0] ?? '';
    Map<String, dynamic> responseBody = response.data;
    checkCookies();
    logger.i('Login User 정보확인 : ${responseBody}');
    return (responseBody, accessToken);
  }

  //회원가입
  Future<Map<String, dynamic>> apiInsertUser(
      Map<String, dynamic> reqData) async {
    final response = await dio.post(
      '/auth/register',
      data: reqData,
    );

    Map<String, dynamic> responseBody = response.data;
    logger.i('respondBody $responseBody');
    return responseBody;
  }

  //accessToken 재발급
  Future<(Map<String, dynamic>, String?)> refreshAccessToken(
      String refreshToken) async {
    // ✅ `/auth/refresh` API 호출
    setCookie(refreshToken);
    checkCookies();

    Response response = await dio.get("/auth/refresh");
    Map<String, dynamic> responseBody = response.data;
    if (response.statusCode == 200 && responseBody['code'] == 1000) {
      String? newAccessToken = response.headers.value('Authorization');
      logger.i("✅ Access Token 갱신 완료: $newAccessToken");
      return (responseBody, newAccessToken);
    }

    logger.w("❌ Refresh Token 만료 또는 오류");
    return (responseBody, '');
  }

  //device 정보
  Future<String> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      logger
          .d('디바이스 정보 : ${androidInfo.version.sdkInt} - ${androidInfo.model}');

      return "Android ${androidInfo.version.sdkInt} - ${androidInfo.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "iOS ${iosInfo.systemVersion} - ${iosInfo.utsname.machine}";
    }
    return "Unknown Device";
  }

  //로그아웃
  Future<Map<String, dynamic>> logout() async {
    Response response = await dio.post(
      '/auth/logout',
    );
    Map<String, dynamic> responseBody = response.data;
    return responseBody;
  }

  Future<void> checkCookies() async {
    List<Cookie> cookies = await cookieJar.loadForRequest(Uri.parse(apiUrl));
    print("✅ 저장된 쿠키 목록: $cookies"); // ✅ 쿠키가 유지되는지 확인
  }

  void setCookie(String refreshToken) {
    logger.i('Cookie에 저장할 refreshToken $refreshToken');
    cookieJar.saveFromResponse(
      Uri.parse(apiUrl), // 요청 도메인과 맞춰야 함
      [Cookie('refreshToken', refreshToken)],
    );

    // ✅ 쿠키 관리자를 Dio에 추가
    dio.interceptors.add(CookieManager(cookieJar));
  }

  //나의 정보 가져오기
  Future<Map<String, dynamic>> getMyInfo() async {
    Response response = await dio.get("/auth/myInfo");
    return response.data;
  }

  Future<Map<String, dynamic>> updateMyInfo(
      Map<String, dynamic> reqData) async {
    Response response = await dio.post("/auth/myInfo", data: reqData);
    return response.data;
  }

  Future<Map<String, dynamic>> findUidByNameAndEmail(
      Map<String, dynamic> reqData) async {
    Response response = await dio.post("/find/uid", data: reqData);
    return response.data;
  }

  Future<Map<String, dynamic>> findPassByUidAndEmail(
      Map<String, dynamic> reqData) async {
    Response response = await dio.post("/find/pass", data: reqData);
    return response.data;
  }

  Future<Map<String, dynamic>> changePass(Map<String, dynamic> reqData) async {
    Response response = await dio.put("/find/pass/change", data: reqData);
    return response.data;
  }

  Future<Map<String, dynamic>> withdrawal(int userid) async {
    Response response = await dio.get('/auth/withdrawal/$userid');
    return response.data;
  }
}
