import 'package:applus_market/screens/chat/chat_room_page.dart';
import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/Login/login_page.dart';
import 'screens/main_screen.dart';

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
        '/chatting_room': (context) => ChatRoomPage(),
      },
      initialRoute: '/home',
    );
  }
}
