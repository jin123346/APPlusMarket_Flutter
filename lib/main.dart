import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/chat/chat_room_page.dart';
import 'views/chat/chat_room_page.dart';
import 'views/login/login_page.dart';

import 'views/main_screen.dart';
import 'views/my/my_logined_page.dart';
import 'views/my/my_settings_page.dart';
import 'views/my/pay_home_page.dart';

/**
 * 2025.01.21 - 김민희 : 결제 홈 화면
 */

void main() {
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
        '/login': (context) => LoginPage(),
        '/home': (context) => MainScreen(),
        '/my': (context) => MyLoginedPage(),
        '/my/settings': (context) => MySettingsPage(),
        '/my/payHome': (context) => PayHomePage(), // 결제 홈 화면
        '/chatting_room': (context) => ChatRoomPage(),
      },
      initialRoute: '/login',
    );
  }
}
