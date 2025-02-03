import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ 로그인 상태 확인 후 자동 이동
  }

  @override
  Widget build(BuildContext context) {
    Future<void>(() async {
      await ref.read(LoginProvider.notifier).initializeAuthState();
    });

    // ✅ 로그인 상태 변화를 감지하고 화면 이동
    ref.listen<SessionUser>(LoginProvider, (previous, next) {
      if (mounted) {
        Future.delayed(Duration(seconds: 2), () {
          if (next.isLoggedIn) {
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            Navigator.popAndPushNamed(context, '/login');
          }
        });
      }
    });
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
