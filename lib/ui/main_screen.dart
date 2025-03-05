import 'package:applus_market/ui/pages/chat/list/chat_list_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home/home_page.dart';
import 'pages/my/my_logined_page.dart';
import 'pages/product/product_register_page.dart';
import 'pages/wish/wish_page.dart';
import 'pages/chat/list/chat_list_page.dart'; // 황수빈 리팩토링

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
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
    final unReadCount = ref.watch(unreadMessagesProvider);
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
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: '관심'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add_circle), label: '등록'),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.message), // 기본 아이콘
                  if (unReadCount > 0) // 안 읽은 메시지가 있을 때만 표시
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unReadCount > 99 ? '99+' : unReadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: '애쁠톡',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person), label: '마이'),
          ],
        ),
      ),
    );
  }
}
