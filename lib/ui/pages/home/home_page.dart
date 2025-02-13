import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/repository/chat/chat_repository.dart';
import 'package:applus_market/data/service/chat_websocket_service.dart';
import 'package:applus_market/ui/widgets/productlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../_core/components/theme.dart';
import '../../../_core/utils/logger.dart';
import '../../../data/gvm/product/productlist_gvm.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController _scrollController;
  ChatRepository chatRepository = ChatRepository();
  ChatService chatService = ChatService();

  @override
  void initState() {
    super.initState();

    // ScrollController를 초기화하고 리스너 등록
    _scrollController = ScrollController()..addListener(_scrollListener);

    // ChatService Notifier로 수정하여 사용하기

    // TODO : 수빈 - (중요) 하드코딩을 지우고 요청 받아온 값으로 처리해야함
    chatService.connect([1, 2, 3, 4, 5, 6, 7, 9, 10]);
    logger.e(chatService.stompClient?.connected);
  }

  // 스크롤 위치가 하단 근처에 도달하면 추가 데이터 요청
  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(productListProvider.notifier).fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 컨트롤러 dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 브랜드 목록 예시
    final brands = [
      'APPLE',
      'SamSung',
      'LG',
      'Asus',
      'Lenova',
    ];

    // productListProvider 상태 구독
    final products = ref.watch(productListProvider);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController, // 스크롤 컨트롤러 적용
        slivers: [
          // 상단 AppBar
          SliverAppBar(
            floating: true,
            titleSpacing: 0,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Text(
                  'APPLUS',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.bangers(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: APlusTheme.primaryColor,
                  ),
                ),
              ],
            ),
            actions: [
              // 알림 아이콘
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.black),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 장바구니 아이콘
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.black),
                    onPressed: () {},
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: const Center(
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // 검색창 영역
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  hintText: '검색어를 입력해주세요',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          // 배너 영역
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 5),
                Image.asset('assets/images/banner/main_banner_1.jpg'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // 브랜드 리스트 영역
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brands[index],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // 상품 목록 영역
          products.isEmpty
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : ProductList(products: products),
        ],
      ),
    );
  }
}
