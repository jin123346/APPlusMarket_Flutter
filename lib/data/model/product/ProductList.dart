import 'package:applus_market/data/model/product/product_info_card.dart';

class ProductListModel {
  bool isFirst;
  bool isLast;
  int lastIndex;
  int size;
  int totalPage;
  List<ProductInfoCard> products;

  ProductListModel(
      {required this.isFirst,
      required this.isLast,
      required this.lastIndex,
      required this.size,
      required this.totalPage,
      required this.products});

  factory ProductListModel.fromMap(Map<String, dynamic> map) {
    return ProductListModel(
      isFirst: map['isFirst'] ?? false,
      isLast: map['isLast'] ?? false,
      lastIndex: map['lastIndex'] ?? 0,
      size: map['size'] ?? 10,
      totalPage: map['totalPage'] ?? 1,
      products: (map['products'] as List<dynamic>? ?? [])
          .map((e) => ProductInfoCard.fromJson(e))
          .toList(),
    );
  }

  // 깊은 복사 (객체 변경 시 활용)
  ProductListModel copyWith({
    bool? isFirst,
    bool? isLast,
    int? lastIndex,
    int? size,
    int? totalPage,
    List<ProductInfoCard>? products,
  }) {
    return ProductListModel(
      isFirst: isFirst ?? this.isFirst,
      isLast: isLast ?? this.isLast,
      lastIndex: lastIndex ?? this.lastIndex,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
      products:
          products ?? List<ProductInfoCard>.from(this.products), // 리스트 깊은 복사
    );
  }

  @override
  String toString() {
    return 'ProductListModel{isFirst: $isFirst, isLast: $isLast, lastIndex: $lastIndex, size: $size, totalPage: $totalPage, products: $products}';
  }
}
