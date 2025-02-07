import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/theme.dart';
import '../../../_core/utils/logger.dart';
import '../../../data/gvm/product/product_gvm.dart';
import '../../../data/model/product/product_info_card.dart';

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

    logger.e("Product Data : $product");
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('상품 보기'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // 신고 버튼 추가
            IconButton(
              icon: const Icon(CupertinoIcons.exclamationmark_triangle),
              onPressed: () => print("신고 버튼 클릭됨"),
            ),
          ],
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
                    Text('${product.updated_at}',
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
                    const Text(
                      '채팅 1 : 관심 4 : 조회 36',
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
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // 찜하기 동작
                },
              ),

              // 가격과 가격 제안 불가를 세로로 배치
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${product.price}원',
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
                  onPressed: () {
                    // 채팅하기 동작
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
}
