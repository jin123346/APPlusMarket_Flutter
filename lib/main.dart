import 'package:applus_market/screens/my/my_logined_page.dart';
import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/Login/login_page.dart';
import 'screens/main_screen.dart';
import 'screens/my/my_settings_page.dart';

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
        // '/payHome' : (context) => PayHomePage(),
      },
      initialRoute: '/login',
    );
  }
}
