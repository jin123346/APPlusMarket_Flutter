import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:applus_market/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../_core/utils/dio.dart';
import '../../_core/utils/logger.dart';
import '../model/auth/login_state.dart';
import '../model/auth/token_manager.dart';

class SessionGVM extends Notifier<SessionUser> {
  final mContext = navigator.currentContext;
  final AuthRepository authRepository = AuthRepository();

  TextEditingController uidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TokenManager tokenManager = TokenManager();
  String? _uid;
  String? _pass;

  @override
  SessionUser build() {
    // _initializeAuthState();
    return SessionUser(
      id: null,
      uid: null,
      isLoggedIn: false,
      accessToken: null,
    );
  }

  void _initializeAuthState() {
    final accessToken = tokenManager.getAccessToken();
    if (accessToken != null) {
      // TODO : 만료 여부 확인 로직 필요
      state = state.copyWith(isLoggedIn: true);
    } else {}
  }

  void login(GlobalKey<FormState> formKey) async {
    AuthRepository authRepository = AuthRepository();

    // 로그인 로직
    _setupDioInterceptor();
    //입력필드값 없을때,
    if (uidController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: mContext!,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Center(
            child: Text(
              '로그인에 실패했습니다.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          content: SizedBox(height: 0),
          // Removes extra padding
          actionsPadding: const EdgeInsets.all(0),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Add cookie deletion logic here
                    Navigator.pop(context);
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(150, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
      return;
    } else if (formKey.currentState?.validate() ?? false) {
      try {
        _uid = uidController.text;
        _pass = passwordController.text;
        (Map<String, dynamic>, String) response =
            await authRepository.login(_uid!, _pass!);
        String accessToken = response.$2;
        Map<String, dynamic> responseDTO = response.$1;

        tokenManager.saveAccessToken(accessToken);
        //state = // 상태 업데이트
        state = state.copyWith(
          id: responseDTO['data']['id'],
          uid: responseDTO['data']['uid'],
          isLoggedIn: true,
        );
        rebuild();
        Navigator.pushNamed(mContext!, '/home');
      } catch (e) {
        logger.e("❌ 로그인 중 오류 발생: $e");
        _showErrorDialog("로그인 실패", e.toString());
      }
    }
  }

  // ✅ 예외 발생 시 UI에 표시할 AlertDialog
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: mContext!,
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

  void _setupDioInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 토큰이 있는 경우 헤더에 추가
          if (state.isLoggedIn && state.accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${state.accessToken}';
          }
          return handler.next(options); // 다음 단계로 요청 전달
        },
      ),
    );
  }

  void logout() async {
    await tokenManager.clearToken();

    resetUser();
    clearControllers();
    logger.d('isLoggedIn 상태 ${state.isLoggedIn}');
    Map<String, dynamic> response = await authRepository.logout();
    logger.d('로그아웃 되었습니다.');

    Navigator.pushNamed(mContext!, "/login");
  }

  void rebuild() {
    uidController.clear();
    passwordController.clear();
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
      isLoggedIn: false,
      accessToken: null,
    );
  }
}

final LoginProvider = NotifierProvider<SessionGVM, SessionUser>(
  () {
    return SessionGVM();
  },
);
