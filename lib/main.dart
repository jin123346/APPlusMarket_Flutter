import 'package:applus_market/screens/Login/login_page.dart';
import 'package:applus_market/screens/home/home_page.dart';
import 'package:applus_market/screens/main_screen.dart';
import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        '/home': (context) => HomePage(),
      },
      initialRoute: '/login',
    );
  }
}
