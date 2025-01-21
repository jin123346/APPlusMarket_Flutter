import 'package:flutter/material.dart';

import 'chat/chat_list_page.dart';
import 'home/home_page.dart';
import 'my/my_page.dart';
import 'product/product_register_page.dart';
import 'wish/wish_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
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
            ChatListPage(),
            MyPage(),
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
