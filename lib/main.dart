import 'package:applus_market/ui/pages/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '_core/theme.dart';
import 'ui/main_screen.dart';
import 'ui/pages/auth/login_page/login_page.dart';
import 'ui/pages/chat/chat_room_page.dart';
import 'ui/pages/my/delivery_page.dart';
import 'ui/pages/my/my_logined_page.dart';
import 'ui/pages/my/my_settings_page.dart';
import 'ui/pages/pay/pay_home_page.dart';

/**
 * 2025.01.21 - 김민희 : 결제 홈 화면
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
        '/my/payHome': (context) => PayHomePage(), // 결제 홈 화면
        '/chatting_room': (context) => ChatRoomPage(),
      },
      initialRoute: '/splash',
    );
  }
}
