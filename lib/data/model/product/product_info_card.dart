/*
* 2025.01.22 - 이도영 : ProductInfoCard 모델링 클래스
*
*/
//상세 정보
import 'package:applus_market/data/model/product/find_product.dart';
import 'package:applus_market/data/model/product/selected_product.dart';

import '../../../_core/utils/apiUrl.dart';
import '../../../_core/utils/logger.dart';

class ProductInfoCard {
  final int? product_id; // 아이디
  final String? title; // 제목
  final String? product_name; //제품명
  final String? content; // 내용
  final String? register_location; // 등록 위치
  final String? register_ip; // 등록 아이피
  final String? created_at; // 생성 일자
  final String? updated_at; // 업데이트 일자
  final int? price; // 가격
  final String? status; // 상태
  final String? deleted_at; // 삭제 일자
  final int? seller_id; // 판매자 아이디
  final String? nickname; //판매자 닉네임
  final bool? is_negotiable; // 네고 가능 여부
  final bool? is_possible_meet_you; // 직거래 가능 여부
  final String? category; // 카테고리
  final String? brand; //브랜드
  final List<String>? images; // 이미지들
  final SelectedProduct? selectedProduct;
  final String? location;
  final FindProduct? findProduct;
  final bool? isWished;
  final int? wishCount;
  final int? hit;

  // 생성자
  ProductInfoCard({
    required this.product_id, // 아이디
    required this.title, // 제목
    required this.product_name, //제품명
    required this.content, // 내용
    this.register_location, // 등록 위치
    required this.register_ip, // 등록 아이피
    required this.created_at, // 생성 일자aa
    required this.updated_at, // 업데이트 일자
    required this.price, // 가격
    required this.status, // 상태
    this.deleted_at, // 삭제 일자
    required this.seller_id, // 판매자 아이디
    required this.nickname, // 판매자 닉네임
    required this.is_negotiable, // 네고 가능 여부
    required this.is_possible_meet_you, // 직거래 가능 여부
    required this.category, // 카테고리
    required this.brand, //브랜드
    required this.images, // 이미지들
    required this.selectedProduct,
    required this.location,
    required this.findProduct,
    this.isWished = false,
    required this.hit,
    required this.wishCount,
  });

  // 수정된 toString() 메서드
  @override
  String toString() {
    return 'ProductInfoCard{'
        'product_id: $product_id, '
        'title: $title, '
        'product_name : $product_name,'
        'images: $images, '
        'content: $content, '
        'register_location: $register_location, '
        'updated_at: $updated_at, '
        'price: $price, '
        'status: $status, '
        'seller_id: $seller_id, '
        'is_negotiable: $is_negotiable, '
        'is_possible_meet_you: $is_possible_meet_you, '
        'category: $category,'
        'brand: $brand}';
  }

  factory ProductInfoCard.fromJson(Map<String, dynamic> json) {
    FindProduct? findProduct = null;
    if (json['findProduct'] != null) {
      findProduct = FindProduct.fromMap(json['findProduct']);
    }

    return ProductInfoCard(
        product_id: json['id'] as int?,
        title: json['title'] as String?,
        product_name: json['product_name'] as String?,
        content: json['content'] as String?,
        register_location: json['register_location'] as String?,
        register_ip: json['register_ip'] as String?,
        created_at: json['created_at'] as String?,
        updated_at: json['updated_at'] as String?,
        price: json['price'] as int?,
        status: json['status'] as String?,
        deleted_at: json['deleted_at'] as String?,
        seller_id: json['seller_id'] as int?,
        nickname: json['nickName'] as String?,
        is_negotiable: json['is_negotiable'] as bool?,
        is_possible_meet_you: json['is_possible_meet_you'] as bool?,
        category: json['category'] as String?,
        brand: json['brand'] as String?,
        images: json['productImage'] != null
            ? ["$apiUrl/uploads/${json['id']}/${json['productImage']}"]
            : [],
        selectedProduct: null,
        location: null,
        findProduct: findProduct,
        isWished: json['wished'],
        wishCount: json['wishCount'],
        hit: json['hit']);
  }
  factory ProductInfoCard.todata(Map<String, dynamic> json) {
    // updatedAt 문자열을 파싱할 때, 만약 서버가 UTC 시간을 보내고 있다면
    // toLocal()을 호출하여 현지 시간으로 변환합니다.
    DateTime updatedDateTime =
        DateTime.tryParse(json['updatedAt'] as String? ?? '')?.toLocal() ??
            DateTime.now();
    logger.i('updatedDateTime : ${updatedDateTime}');
    String formattedUpdatedAt;
    DateTime now = DateTime.now();
    logger.i('now : $now');
    // 만약 updatedDateTime이 오늘이면 시간 차이를 계산
    if (updatedDateTime.year == now.year &&
        updatedDateTime.month == now.month &&
        updatedDateTime.day == now.day) {
      Duration diff = now.difference(updatedDateTime);
      if (diff.inHours >= 1) {
        formattedUpdatedAt = "${diff.inHours}시간 전";
      } else if (diff.inMinutes >= 1) {
        formattedUpdatedAt = "${diff.inMinutes}분 전";
      } else {
        formattedUpdatedAt = "방금 전";
      }
    } else {
      // 오늘이 아니라면 날짜만 출력 (예: 2025-02-04)
      formattedUpdatedAt =
          "${updatedDateTime.year}-${updatedDateTime.month.toString().padLeft(2, '0')}-${updatedDateTime.day.toString().padLeft(2, '0')}";
    }

    FindProduct? findProduct = null;
    if (json['findProduct'] != null) {
      findProduct = FindProduct.fromMap(json['findProduct']);
    }

    logger.i("관심상품 들어오는가 ? ${json['isWished']}");
    return ProductInfoCard(
        product_id: json['id'] as int?,
        title: json['title'] as String?,
        product_name: json['productName'] as String?,
        content: json['content'] as String?,
        register_location: json['registerLocation'] as String?,
        register_ip: json['registerIp'] as String?,
        created_at: json['createdAt'] as String?,
        updated_at: json['updateAt'] as String?,
        price: json['price'] as int?,
        status: json['status'] as String?,
        deleted_at: json['deletedAt'] as String?,
        seller_id: json['sellerId'] as int?,
        nickname: json['nickName'] as String?,
        is_negotiable: json['isNegotiable'] as bool?,
        is_possible_meet_you: json['isPossibleMeetYou'] as bool?,
        category: json['category'] as String? ?? null,
        brand: json['brand'] as String? ?? "기타",
        images: (json['images'] as List<dynamic>?)?.map((image) {
              return "$apiUrl/uploads/${json['id']}/${image['uuidName']}";
            }).toList() ??
            [], // 이미지 매핑
        //TODO: 선택된 product 가져오기
        selectedProduct: null,
        location: json['location'] ?? null,
        findProduct: findProduct,
        isWished: json['wished'] ?? false,
        wishCount: json['wishCount'] ?? 0,
        hit: json['hit'] ?? 0);
  }

  ProductInfoCard copyWith({
    int? product_id, // 아이디
    String? title, // 제목
    String? product_name, //제품명
    String? content, // 내용
    String? register_location, // 등록 위치
    String? register_ip, // 등록 아이피
    String? created_at, // 생성 일자
    String? updated_at, // 업데이트 일자
    int? price, // 가격
    String? status, // 상태
    String? deleted_at, // 삭제 일자
    int? seller_id, // 판매자 아이디
    String? nickname, //판매자 닉네임
    bool? is_negotiable, // 네고 가능 여부
    bool? is_possible_meet_you, // 직거래 가능 여부
    String? category, // 카테고리
    String? brand, //브랜드
    List<String>? images, // 이미지들
    SelectedProduct? selectedProduct,
    String? location,
    FindProduct? findProduct,
    bool? isWished,
    int? wishCount,
    int? hit,
  }) {
    return ProductInfoCard(
      product_id: product_id ?? this.product_id,
      title: title ?? this.title,
      product_name: product_name ?? this.product_name,
      content: content ?? this.content,
      register_ip: register_ip ?? this.register_ip,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      price: price ?? this.price,
      status: status ?? this.status,
      seller_id: seller_id ?? this.seller_id,
      nickname: nickname ?? this.nickname,
      is_negotiable: is_negotiable ?? this.is_negotiable,
      is_possible_meet_you: is_possible_meet_you ?? this.is_possible_meet_you,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      images: images ?? this.images,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      location: location ?? this.location,
      findProduct: findProduct ?? this.findProduct,
      isWished: isWished ?? this.isWished,
      wishCount: wishCount ?? this.wishCount,
      hit: hit ?? this.hit,
    );
  }
}
