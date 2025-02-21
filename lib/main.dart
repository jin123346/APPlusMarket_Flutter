import 'package:applus_market/_core/utils/logger.dart';
import 'package:applus_market/data/gvm/websocket/websocket_notifier.dart';
import 'package:applus_market/ui/pages/chat/list/chat_list_page.dart';
import 'package:applus_market/ui/pages/my/my_info_page.dart';
import 'package:applus_market/ui/pages/my/withdrawal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/theme.dart';
import '_core/utils/shared_preferences.dart';
import 'data/gvm/geo/location_gvm.dart';
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
import 'ui/pages/my/delivery_modify_page.dart';
import 'ui/pages/my/delivery_page.dart';
import 'ui/pages/my/delivery_register_page.dart';
import 'ui/pages/my/my_logined_page.dart';
import 'ui/pages/my/my_settings_page.dart';
import 'ui/pages/my/widgets/withdrawal_warning_dialog.dart';
import 'ui/pages/pay/charge_page/charge_page.dart';
import 'ui/pages/pay/pay_home_page.dart';
import 'ui/pages/pay/widgets/pay_send_page.dart';
import 'ui/pages/product/product_register_page.dart';
import 'ui/pages/splash/splash_screen.dart';

/**
 * 2025.01.21 - 김민희 : 결제 홈 화면
 * 2025.01.24 - 황수빈 : 아이디 찾기 라우터 추가
 * 2025.01.25 - 하진희 : 회원가입화면 라우터 추가
 * 2025.01.29 - 하진희 : dotenv 파일 로드 가능하도록 기능 추가
 * 2025.02.04 - 김민희 : 결제 > 충전 첫 화면 라우터 추가
 */

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // .env 파일 로드+
  await SharedPrefHelper.init(); // SharedPreferences 초기화
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ChatService Notifier로 수정하여 사용하기
    WebSocketNotifier notifier = ref.watch(webSocketProvider.notifier);

    notifier.connect();

    logger.e(
        'HomePage initState() - stompClient 연결 여부 ${notifier.stompClient?.connected}');
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
        '/withdrawal': (context) => WithdrawalPage(),
        '/withdrawal/confirm': (context) => WithdrawalWarningDialog(),
        '/my': (context) => MyLoginedPage(),
        '/my/info': (context) => MyInfoPage(),
        '/my/settings': (context) => MySettingsPage(),
        '/my/delivery': (context) => DeliveryPage(),
        '/my/delivery/register': (context) => DeliveryRegisterPage(),
        '/my/delivery/modify': (context) => DeliveryMoifyPage(),
        '/my/payHome': (context) => PayHomePage(), // 결제 홈 화면
        '/pay/charge': (context) => ChargePage(), // 충전 화면
        '/pay/send': (context) => PaySendPage(), // 송금 화면
        '/chat/list': (context) => ChatListPage(),
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
