import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:applus_market/main.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../_core/utils/apiUrl.dart';
import '../../_core/utils/dio.dart';
import '../../_core/utils/logger.dart';
import '../model/auth/login_state.dart';
import '../model/auth/token_manager.dart';

class SessionGVM extends Notifier<SessionUser> {
  final mContext = navigatorkey.currentContext!;
  final AuthRepository authRepository = AuthRepository();

  TextEditingController uidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TokenManager tokenManager = TokenManager();
  String? _uid;
  String? _pass;

  @override
  SessionUser build() {
    return SessionUser(
      id: null,
      uid: null,
      nickname: null,
      isLoggedIn: false,
      accessToken: null,
    );
  }

  Future<void> initializeAuthState() async {
    String? accessToken = await tokenManager.getAccessToken();
    if (accessToken != null) {
      logger.i("✅ 기존 Access Token 발견: $accessToken");
      bool isDecode = decodeAccessToken(accessToken);
      if (isDecode) {
        logger.i("✅ 기존 Access Token 으로 셋팅: $state");

        Navigator.pushNamed(mContext!, "/home");
      }
    }
    // ✅ 2. Access Token이 없으면, Refresh Token을 사용하여 자동 로그인 시도
    logger.i("🔄 Access Token 없음, Refresh Token으로 재로그인 시도...");
    String? refreshToken = await tokenManager.getRefreshToken();
    logger.i('refreshToken 존재X $refreshToken');
    if (refreshToken != null) {
      logger.d('여기');
      (Map<String, dynamic>, String?) tuple =
          await authRepository.refreshAccessToken(refreshToken);
      Map<String, dynamic> responseBody = tuple.$1;
      String? newAccessToken = tuple.$2;

      if (responseBody['code'] == 1000 && newAccessToken != null) {
        tokenManager.saveAccessToken(newAccessToken);
        bool isDecode = decodeAccessToken(newAccessToken);
        if (isDecode) {
          logger.i("✅ 자동 로그인 성공");

          _setupDioInterceptor(newAccessToken);
          Navigator.pushNamed(mContext!, "/home");
        }
      } else {
        logger.w("❌ 자동 로그인 실패 - 로그인 화면으로 이동");
        Navigator.pushNamed(mContext, "/login");
      }
    } else {
      logger.w("❌ refreshToken 존재 X  - 로그인 화면으로 이동");
      Navigator.pushNamed(mContext, "/login");
    }
  }

  //로그인
  void login(GlobalKey<FormState> formKey) async {
    AuthRepository authRepository = AuthRepository();
    // 로그인 로직
    //입력필드값 없을때,
    if (uidController.text.isEmpty || passwordController.text.isEmpty) {
      DialogHelper.showAlertDialog(
        context: mContext,
        title: '로그인 실패',
        content: '아이디 및 비밀번호를 입력해주세요.',
        onConfirm: () {
          Navigator.pop(mContext);
        },
      );
      return;
    } else if (formKey.currentState?.validate() ?? false) {
      try {
        _uid = uidController.text.trim();
        _pass = passwordController.text.trim();
        (Map<String, dynamic>, String) response =
            await authRepository.login(_uid!, _pass!);
        String accessToken = response.$2;
        Map<String, dynamic> responseDTO = response.$1;

        if (responseDTO['code'] == 1000) {
          tokenManager.saveAccessToken(accessToken);
          List<Cookie> cookies =
              await cookieJar.loadForRequest(Uri.parse(apiUrl));
          String? refreshToken = cookies
              .firstWhere((cookie) => cookie.name == "refreshToken")
              .value;
          tokenManager.saveRefreshToken(refreshToken);
          logger.d('저장된 refreshToken!!! $refreshToken');
          //state = // 상태 업데이트
          state = state.copyWith(
            id: responseDTO['data']['id'],
            uid: responseDTO['data']['uid'],
            nickname: responseDTO['data']['nickName'],
            isLoggedIn: true,
          );
          _setupDioInterceptor(accessToken);
          clearControllers();
          Navigator.pushNamed(mContext, '/home');
        } else {
          ExceptionHandler.handleException(
              responseDTO['message'], StackTrace.current);

          DialogHelper.showAlertDialog(
            context: mContext,
            title: '로그인 실패',
            content: responseDTO['message'],
            onConfirm: () {
              Navigator.pop(mContext);
            },
          );
          return;
          //_showErrorDialog("로그인 실패", responseDTO['message']);
        }
      } catch (e, stackTrace) {
        logger.e("❌ 로그인 중 오류 발생: $e");
        ExceptionHandler.handleException('로그인 통신 오류', stackTrace);
        DialogHelper.showAlertDialog(
            context: mContext,
            title: '로그인 실패',
            content: '통신 에러 ',
            onConfirm: () {
              Navigator.pop(mContext);
            });
      }
    }
  }

  // ✅ 예외 발생 시 UI에 표시할 AlertDialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: mContext,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _setupDioInterceptor(String accessToken) {
    logger.w('dio에 accessToken 넣기 : $accessToken');
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 토큰이 있는 경우 헤더에 추가
          if (state.isLoggedIn) {
            options.headers['Authorization'] = '${accessToken}';
          }
          return handler.next(options); // 다음 단계로 요청 전달
        },
      ),
    );
  }

  void logout() async {
    try {
      await tokenManager.clearToken();
      logger.d('isLoggedIn 상태 ${state.isLoggedIn}');

      Map<String, dynamic> response = await authRepository.logout();

      // logger.e('! [] ==  이용시 : ${!response['code'] == 1009}'); 런타임 시 여기서 에러

      if (response['code'] != 1010) {
        _showErrorDialog('로그아웃 API 요청 에러', response['message']);
        return;
      }

      resetUser();
      await tokenManager.clearToken();

      // 쿠키 삭제 - Refresh Token 제거
      await cookieJar.deleteAll();
      logger.e('로그아웃 되었습니다.');

      // 이전 화면 다 파괴
      Navigator.pushNamedAndRemoveUntil(
        mContext,
        '/login',
        (route) => false,
      );
    } catch (e, stackTrace) {
      logger.e('로그아웃 처리 중 오류 발생 $e, $stackTrace');
      throw Exception(e);
    }
  }

  // 회원가입

  Future<void> join(Map<String, dynamic> body) async {
    try {
      Map<String, dynamic> responseBody =
          await authRepository.apiInsertUser(body);
      if (responseBody['code'] == 1100) {
        logger.i('회원가입 성공!');
        Navigator.popAndPushNamed(mContext, '/home');
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('회원가입 실패', stackTrace);
    }
  }

  void clearControllers() {
    uidController.clear();
    passwordController.clear();
  }

  void dispose() {
    uidController.dispose();
    passwordController.dispose();
  }

  //sessionUser 초기화 시키기
  void resetUser() {
    state = SessionUser(
      id: null,
      uid: null,
      nickname: null,
      isLoggedIn: false,
      accessToken: null,
    );
  }

  bool decodeAccessToken(String token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    String uid = decodedToken['sub']; // 유저 ID
    int? userId = decodedToken['id'] is int
        ? decodedToken['id']
        : int.tryParse(decodedToken['id'].toString());
    if (uid == null || userId == null) {
      logger.e("JWT 토큰 파싱 오류: 필수 정보가 없습니다.");
      return false;
    }

    DateTime expiryDate = JwtDecoder.getExpirationDate(token); //  만료 시간
    logger.i(" 토큰 만료 시간: $expiryDate, 현재 시간: ${DateTime.now()}");
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    logger.i('여기 만료되지않음!!! ${decodedToken} ');

    state = state.copyWith(
        id: decodedToken['id'],
        uid: uid,
        nickname: decodedToken['nickName'],
        isLoggedIn: true);

    logger.i('상태 업데이트 완료! $state');
    return true;
  }
}

final LoginProvider = NotifierProvider<SessionGVM, SessionUser>(
  () {
    return SessionGVM();
  },
);
