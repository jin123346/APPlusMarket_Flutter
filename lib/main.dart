import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/theme.dart';
import 'data/gvm/session_gvm.dart';
import 'ui/main_screen.dart';
import 'ui/pages/auth/find_id_page/find_id_page.dart';
import 'ui/pages/auth/find_id_page/find_id_result_page.dart';
import 'ui/pages/auth/find_pass_page/find_pass_change_page.dart';
import 'ui/pages/auth/find_pass_page/find_pass_page.dart';
import 'ui/pages/auth/find_pass_page/pass_change_result_page.dart';
import 'ui/pages/auth/join_page/join_insert_page/insert_email_page.dart';

import 'ui/pages/auth/join_page/join_insert_page/insert_hp_page.dart';
import 'ui/pages/auth/join_page/join_insert_page/insert_name_page.dart';
import 'ui/pages/auth/join_page/join_insert_page/insert_password_page.dart';
import 'ui/pages/auth/join_page/join_insert_page/insert_uid_page.dart';
import 'ui/pages/auth/join_page/join_insert_page/join_check_page.dart';
import 'ui/pages/auth/join_page/join_page.dart';
import 'ui/pages/auth/login_page/login_page.dart';
import 'ui/pages/chat/room/chat_room_page.dart';
import 'ui/pages/my/delivery_page.dart';
import 'ui/pages/my/delivery_register_page.dart';
import 'ui/pages/my/my_logined_page.dart';
import 'ui/pages/my/my_settings_page.dart';
import 'ui/pages/pay/pay_home_page.dart';
import 'ui/pages/splash/splash_screen.dart';

/**
 * 2025.01.21 - 김민희 : 결제 홈 화면
 * 2025.01.24 - 황수빈 : 아이디 찾기 라우터 추가
 * 2025.01.25 - 하진희 : 회원가입화면 라우터 추가
 * 2025.01.29 - 하진희 : dotenv 파일 로드 가능하도록 기능 추가
 */

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      title: 'APPLUS Market',
      theme: APlusTheme.lightTheme,
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/join': (context) => JoinPage(),
        '/join/emailLogin': (context) => InsertNamePage(),
        '/join/insertUid': (context) => InsertUidPage(),
        '/join/insertPass': (context) => InsertPasswordPage(),
        '/join/insertHp': (context) => InsertHpPage(),
        '/join/insertEmail': (context) => InsertEmailPage(),
        '/join/check': (context) => JoinCheckPage(),
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
        '/find_pass_change': (context) => FindPassChangePage(),
        '/pass_change_result': (context) => PassChangeResultPage(),
      },
      initialRoute: '/splash',
    );
  }
}
