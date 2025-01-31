import 'package:flutter/material.dart';

import 'pages/chat/list/widgets/chat_list_body.dart';
import 'pages/home/home_page.dart';
import 'pages/my/my_logined_page.dart';
import 'pages/product/product_register_page.dart';
import 'pages/wish/wish_page.dart';
import 'pages/chat/list/chat_list_page.dart'; // 황수빈 리팩토링

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageIndex = 0;
  }

  void _changePageIndex(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: pageIndex,
          children: [
            HomePage(),
            WishPage(),
            ProductRegisterPage(),
            // ProductListSearch(),
            ChatListPage(),
            MyLoginedPage(),
            //PayHomePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: pageIndex,
          onTap: (index) {
            _changePageIndex(index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '관심'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: '등록'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: '애쁠톡'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
          ],
        ),
      ),
    );
  }
}
