import 'package:applus_market/ui/pages/auth/find_id_page/find_id_page.dart';
import 'package:applus_market/ui/pages/auth/find_id_page/find_id_result_page.dart';
import 'package:applus_market/ui/pages/auth/find_pass_page/find_pass%20_page.dart';
import 'package:applus_market/ui/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_core/theme.dart';
import 'ui/main_screen.dart';
import 'ui/pages/auth/login_page/login_page.dart';
import 'ui/pages/chat/chat_room_page.dart';
import 'ui/pages/my/delivery_page.dart';
import 'ui/pages/my/delivery_register_page.dart';
import 'ui/pages/my/my_logined_page.dart';
import 'ui/pages/my/my_settings_page.dart';
import 'ui/pages/pay/pay_home_page.dart';
import 'ui/pages/splash/splash_screen.dart';

/**
 * 2025.01.21 - 김민희 : 결제 홈 화면
 * 2025.01.24 - 황수빈 : 아이디 찾기 라우터 추가
 */

void main() async {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'APPLUS Market',
      theme: APlusTheme.lightTheme,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => MainScreen(),
        '/my': (context) => MyLoginedPage(),
        '/my/settings': (context) => MySettingsPage(),
        '/my/delivery': (context) => DeliveryPage(),
        '/my/delivery/register': (context) => DeliveryRegisterPage(),
        '/my/payHome': (context) => PayHomePage(), // 결제 홈 화면
        '/chatting_room': (context) => ChatRoomPage(),
        '/find_id': (context) => FindIdPage(),
        '/find_id_result': (context) => FindIdResultPage(),
        '/find_pass': (context) => FindPassPage(),


      },
      initialRoute: '/splash',
    );
  }
}
