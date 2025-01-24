import 'package:flutter/material.dart';
import '../../../data/model/product_card.dart';
import '../../widgets/productlist.dart';
import '../../widgets/searchcustombar.dart';

/*
* 2025.01.21 - 이도영 : 검색 상품 출력
*
* */
class ProductListSearch extends StatefulWidget {
  const ProductListSearch({super.key});

  @override
  State<ProductListSearch> createState() => _ProductListState();
}

class _ProductListState extends State<ProductListSearch> {
  // 선택된 값 저장 변수
  //String selectedCategory = '카테고리';
  String selectedSort = '등록일순';
  String selectedPrice = '가격';

  // 체크박스 상태 변수
  bool isNegotiable = false;
  bool excludeCompleted = false;
  bool directTransaction = false;

  // 카테고리, 정렬 옵션 데이터
  //final categories = ['카테고리', '노트북', '휴대폰'];
  final sortOptions = ['등록일순', '최신순', '오래된순'];
  final priceOptions = ['가격', '낮은가격순', '높은가격순'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              titleSpacing: 0,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text('상품 리스트'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Searchcustombar(
                  hintText: '검색어를 입력해주세요',
                  onChanged: (value) {
                    // 검색 입력 처리
                    print('검색어: $value');
                  },
                ),
              ),
            ),
            // 카테고리 + 체크박스 한 줄 출력
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.grey.shade300, width: 1), // 아래쪽에만 테두리
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // 드롭다운 버튼들
                      // _buildDropdownButton(
                      //   items: categories,
                      //   value: selectedCategory,
                      //   onChanged: (value) {
                      //     setState(() {
                      //       selectedCategory = value!;
                      //     });
                      //   },
                      // ),
                      _buildDropdownButton(
                        items: sortOptions,
                        value: selectedSort,
                        onChanged: (value) {
                          setState(() {
                            selectedSort = value!;
                          });
                        },
                      ),
                      _buildDropdownButton(
                        items: priceOptions,
                        value: selectedPrice,
                        onChanged: (value) {
                          setState(() {
                            selectedPrice = value!;
                          });
                        },
                      ),
                      // 체크박스들
                      _buildCheckbox(
                        title: '네고 가능',
                        value: isNegotiable,
                        onChanged: (value) {
                          setState(() {
                            isNegotiable = value!;
                          });
                        },
                      ),
                      _buildCheckbox(
                        title: '판매완료 제외',
                        value: excludeCompleted,
                        onChanged: (value) {
                          setState(() {
                            excludeCompleted = value!;
                          });
                        },
                      ),
                      _buildCheckbox(
                        title: '직거래 가능',
                        value: directTransaction,
                        onChanged: (value) {
                          setState(() {
                            directTransaction = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ProductList(products: products),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required List<String> items,
    required String value,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DropdownButton<String>(
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ),
            )
            .toList(),
        onChanged: onChanged,
        underline: Container(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildCheckbox({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
          Text(title),
        ],
      ),
    );
  }
}
