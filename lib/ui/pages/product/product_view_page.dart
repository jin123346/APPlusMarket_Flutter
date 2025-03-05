import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/product/find_product.dart';
import 'package:applus_market/ui/pages/chat/room/chat_room_page.dart';
import 'package:applus_market/ui/pages/chat/room/chat_room_page_view_model.dart';
import 'package:applus_market/ui/pages/components/time_ago.dart';
import 'package:applus_market/ui/pages/product/product_detail_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/theme.dart';
import '../../../_core/utils/logger.dart';
import '../../../_core/utils/priceFormatting.dart';
import '../../../data/gvm/product/product_gvm.dart';
import '../../../data/model/product/product_info_card.dart';
import 'package:url_launcher/url_launcher.dart';

/*
  2025.01.22 - 이도영 : 상품 정보 출력화면
*/
class ProductViewPage extends ConsumerStatefulWidget {
  final int productId;
  const ProductViewPage({super.key, required this.productId});

  @override
  ConsumerState<ProductViewPage> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductViewPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true; // 로딩 상태
  String? _errorMessage; // 에러 메시지
  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  //상품을 가지고 오는 동안 데이터가 로딩 됩니다.
  Future<void> _loadProductData() async {
    try {
      await ref.read(productProvider.notifier).selectProduct(widget.productId);
      setState(() {
        _isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "상품 데이터를 가져오는 데 실패했습니다. 다시 시도해주세요.";
        logger.e("Error loading product data: $e");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = ref.watch(productProvider); // 상태 자동 반영
    final productid = product.product_id; // 상품 아이디
    String? currentTime = timeAgo(product.updated_at ?? product.created_at);
    final FindProduct? findProduct = product.findProduct;
    if (_isLoading) {
      // 로딩 중인 경우
      return Scaffold(
        appBar: AppBar(
          title: const Text('상품 보기'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_errorMessage != null) {
      // 에러가 발생한 경우
      return Scaffold(
        appBar: AppBar(
          title: const Text('상품 보기'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProductData,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }
    //logger.e("관심상품 상태 : ${product.isWished ?? false}");

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('상품 보기'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          // actions: [
          //   // 신고 버튼 추가
          //   IconButton(
          //     icon: const Icon(CupertinoIcons.),
          //     onPressed: () => print("신고 버튼 클릭됨"),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 사진 + 판매자 정보
              Container(
                color: Colors.white, // 흰색 배경 추가
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: Stack(
                        children: [
                          // 이미지 가로 스크롤
                          PageView.builder(
                            controller: _pageController,
                            itemCount:
                                product.images?.length, // 이미지 리스트의 길이를 사용
                            itemBuilder: (context, index) {
                              return Image.network(
                                product.images![index], // 동적으로 각 이미지 표시
                                // fit: BoxFit.cover,
                              );
                            },
                          ),
                          // 페이지 번호 표시
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              color: Colors.black.withOpacity(0.5),
                              child: Text(
                                '${_currentPage + 1} / ${product.images?.length}', // 페이지 인덱스 (1부터 시작하도록 +1)
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 판매자 정보
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade300,
                            child: const Icon(Icons.person, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${product.nickname}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //register_location 널이 아닐경우 수정 필요
                              if (product.register_location != null)
                                Text('${product.register_location}'),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            // 여기 Row로 변경
                            children: [
                              Text(
                                '3.5',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 4), // 간격 추가
                              Icon(Icons.star, color: Colors.yellow),
                            ],
                          ), // 상태 표시 아이콘
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 제목, 날짜, 카테고리, 브랜드 영역
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white, // 흰색 배경 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.title}',
                      style: CustomTextTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    // 날짜
                    Text('${currentTime}',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),

                    // 카테고리와 상품상태를 세로로 배치
                    Row(
                      children: [
                        // 고정된 너비로 카테고리 레이블 설정
                        const SizedBox(
                          width: 70, // 고정 너비 설정
                          child: Text(
                            '카테고리 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text('${product.category}',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // 고정된 너비로 상품상태 레이블 설정
                        SizedBox(
                          width: 70, // 고정 너비 설정
                          child: Text(
                            '브랜드 ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${product.brand}',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: findProduct != null && findProduct.name != null,
                      child: Container(
                        child: Column(
                          children: [
                            if (findProduct != null)
                              _buildBrand('상품명', findProduct!.name!),
                            const SizedBox(height: 8),
                            if (findProduct != null)
                              _buildBrand(
                                  '상품코드', findProduct.productDetailCode!),
                            const SizedBox(height: 8),
                            if (findProduct != null)
                              _buildBrand(
                                  '공홈가',
                                  formatPrice(findProduct.finalPrice!.toInt())
                                      .toString()),
                            const SizedBox(height: 8),
                            if (findProduct?.productUrl != null)
                              Visibility(
                                visible: findProduct!.productUrl != null,
                                child: _buildUrl('상세링크', findProduct.goodsId,
                                    findProduct.name!),
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 상품 설명과 기타 정보 영역
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white, // 흰색 배경 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.content}',
                    ),
                    const SizedBox(height: 16),
                    // 현재는 고정으로 해놨지만 추후 기능을 추가 해야 합니다.
                    Text(
                      //TODO: 챗팅 방 횟수 적기
                      '채팅 1 : 관심 ${product.wishCount} : 조회 ${product.hit}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, // 왼쪽으로 배치
            children: [
              // 하트 아이콘 (찜하기)
              IconButton(
                icon: (product.isWished!)
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  //로그인 유무 확인
                  SessionUser? user = ref.watch(LoginProvider);
                  if (user == null) {
                    DialogHelper.showAlertDialog(
                      context: context,
                      title: '로그인 하시겠습니까?',
                      isCanceled: true,
                      onConfirm: () {
                        Navigator.pushNamed(context, "/login");
                      },
                    );
                    return;
                  }
                  // 찜하기 동작
                  ref
                      .read(productProvider.notifier)
                      .updateWishList(productid!, user.id!);
                },
              ),

              // 가격과 가격 제안 불가를 세로로 배치
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${formatPrice(product.price!)}원',
                        style: CustomTextTheme.titleMedium),
                    const SizedBox(height: 4),
                    // is_negotiable 값에 따라 가격 제안 가능/불가 텍스트 출력
                    Text(
                      product.is_negotiable! ? '가격 제안 가능' : '가격 제안 불가',
                    ),
                  ],
                ),
              ),

              // 채팅하기 버튼 텍스트 보이기
              const Spacer(), // 오른쪽 끝으로 밀기
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () async {
                    SessionUser sessionUser = ref.watch(LoginProvider);
                    int result = await ref
                        .watch(chatRoomProvider.notifier)
                        .createChatRoom(product.seller_id!, product.product_id!,
                            sessionUser.id!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatRoomPage(chatRoomId: result), // 해당 ID를 전달
                      ),
                    );
                  },
                  child: const Text('채팅하기'), // 채팅하기 텍스트 보이도록 수정
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(String title, Object content) {
    return Row(
      children: [
        // 고정된 너비로 상품상태 레이블 설정
        SizedBox(
          width: 70, // 고정 너비 설정
          child: Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            '${content}',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildUrl(String title, String? goodId, String goodNm) {
    return Row(
      children: [
        // 고정된 너비로 상품상태 레이블 설정
        SizedBox(
          width: 70, // 고정 너비 설정
          child: Text(
            '$title',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: (goodId != null) // 링크인 경우
              ? GestureDetector(
                  onTap: () {
                    // ✅ 링크 클릭 시 Dialog로 WebView 호출
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        logger.i(
                            'https://www.samsung.com/sec/cxhr/goods/getGoodsSpecList?goodsId=${goodId}&goodsNm=${goodNm}');
                        return ProductDetailWebView(
                            productUrl:
                                'https://www.samsung.com/sec/cxhr/goods/getGoodsSpecList?goodsId=${goodId}&goodsNm=${goodNm}');
                      },
                    );
                  },
                  child: Text(
                    '상세보기', // 여기에 원하는 텍스트로 표시
                    style: TextStyle(
                      color: Colors.blue, // 링크처럼 보이도록 파란색
                      decoration: TextDecoration.underline, // 밑줄 추가
                    ),
                  ),
                )
              : Text(
                  '없음',
                  style: TextStyle(color: Colors.grey),
                ),
        ),
      ],
    );
  }
}
