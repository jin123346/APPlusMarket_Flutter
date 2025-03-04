import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/exception_handler.dart';
import '../../../_core/utils/logger.dart';
import '../../../_core/utils/secure_storage.dart';
import '../../../data/gvm/geo/location_gvm.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
    ref.read(locationProvider.notifier);
  }

  Future<void> _checkLoginState() async {
    try {
      String? refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        logger.i('여기로 안들어와??');
        _navigateToLogin();
      } else {
        logger.i('여기로 안들어와??');
        await ref.read(LoginProvider.notifier).initializeAuthState();
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('자동로그인 중 오류 발생', stackTrace);
      _navigateToLogin();
    }
  }

  //로그인 페이지 이동 메서드
  void _navigateToLogin() {
    //2초 동안 대기 후 로그인 페이지 이동 처리

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.popAndPushNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/applogo_logo_rd.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
