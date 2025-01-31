import 'package:applus_market/data/model/auth/token_manager.dart';
import 'package:applus_market/data/model/data_responseDTO.dart';
import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';
import 'tokens.dart';
/*
 2025.1.28 하진희 - 로그인 상태관리
 */

class LoginState {
  final String? uid;
  final bool isLoggedIn;
  final String? token;

  LoginState({this.isLoggedIn = false, this.token, this.uid});

  LoginState copyWith({bool? isLoggedIn, String? token}) {
    return LoginState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
    );
  }
}

class LoginController extends Notifier<LoginState> {
  TextEditingController uidController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<TextEditingController> controllers = [];
  late final TokenManager tokenManager;
  String? _uid;
  String? _pass;

  @override
  LoginState build() {
    tokenManager = TokenManager();
    _initializeAuthState();
    return LoginState();
  }

  Future<void> _initializeAuthState() async {
    final accessToken = await tokenManager.getAccessToken();
    if (accessToken != null) {
      state = state.copyWith(isLoggedIn: true, token: accessToken);
    }
  }

  void login(BuildContext context) async {
    AuthRepository authRepository = AuthRepository(dio: dio);

    // 로그인 로직
    _setupDioInterceptor();
    if (uidController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
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
          content: SizedBox(height: 0), // Removes extra padding
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
        Tokens tokens = await authRepository.login(_uid!, _pass!);
        String accessToken = tokens.token;

        state = LoginState(isLoggedIn: true, token: accessToken); // 상태 업데이트

        Navigator.pushNamed(context, '/home');
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('로그인 실패'),
                  content: Text('로그인 중 오류가 발생했습니다: $e'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('확인'),
                    ),
                  ],
                ));
      }
    }
  }

  void _setupDioInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 토큰이 있는 경우 헤더에 추가
          if (state.isLoggedIn && state.token != null) {
            options.headers['Authorization'] = 'Bearer ${state.token}';
          }
          return handler.next(options); // 다음 단계로 요청 전달
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await tokenManager.clearTokens();
    state = LoginState(isLoggedIn: false, token: "");
    clearControllers();
    logger.d('isLoggedIn 상태 ${state.isLoggedIn}');
    rebuild();
    logger.d('로그아웃 되었습니다.');

    Navigator.pushNamed(context, "/login");
  }

  void rebuild() {
    uidController.clear();
    passwordController.clear();
    formKey = GlobalKey<FormState>(); // 새로운 GlobalKey 생성
  }

  void clearControllers() {
    uidController.clear();
    passwordController.clear();
  }

  void dispose() {
    uidController.dispose();
    passwordController.dispose();
  }
}

final LoginControllerProvider = NotifierProvider<LoginController, LoginState>(
  () {
    return LoginController();
  },
);
