/*
* 2025.01.22 - 이도영 : ProductInfoCard 모델링 클래스
*
*/
//상세 정보
import '../../../_core/utils/apiUrl.dart';

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
  final String? seller_id; // 판매자 아이디
  final bool? is_negotiable; // 네고 가능 여부
  final bool? is_possible_meet_you; // 직거래 가능 여부
  final String? category; // 카테고리
  final String? brand; //브랜드
  final List<String>? images; // 이미지들

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
    required this.is_negotiable, // 네고 가능 여부
    required this.is_possible_meet_you, // 직거래 가능 여부
    required this.category, // 카테고리
    required this.brand, //브랜드
    required this.images, // 이미지들
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
      seller_id: json['seller_id'] as String?,
      is_negotiable: json['is_negotiable'] as bool?,
      is_possible_meet_you: json['is_possible_meet_you'] as bool?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      images: json['productImage'] != null
          ? [
              "$apiUrl/uploads/${json['id']}/${json['productImage']}"
            ] // ✅ 동적 BASE_URL 적용
          : [],
    );
  }
}

// List<ProductInfoCard> products = [
//   ProductInfoCard(
//     product_id: 1,
//     title: '맥북 프로 14 2024년형 새상품 팝니다',
//     product_name: '노트북',
//     images: [
//       'https://picsum.photos/id/910/300/300',
//       'https://picsum.photos/id/890/300/300',
//     ], // 이미지 리스트
//     content: '새상품, 박스포장 그대로, 맥북 프로 14인치 2024년형',
//     register_location: '서울시 강남구',
//     updated_at: '2024-01-01',
//     price: 3000000,
//     status: '새 상품',
//     seller_id: 'seller_001',
//     is_negotiable: true,
//     is_possible_meet_you: false,
//     category: '노트북',
//     brand: '삼성',
//   ),
//   ProductInfoCard(
//     product_id: 2,
//     title: '아이패드 프로 11인치 4세대',
//     product_name: '노트북',
//     images: ['https://picsum.photos/id/890/200/100'],
//     content: '아이패드 프로 11인치 4세대, 미개봉 새상품',
//     register_location: '부산시 해운대구',
//     updated_at: '2024-02-01',
//     price: 1200000,
//     status: '새 상품',
//     seller_id: 'seller_002',
//     is_negotiable: false,
//     is_possible_meet_you: true,
//     category: '태블릿',
//   ),
//   ProductInfoCard(
//     product_id: 3,
//     title: '삼성 갤럭시 Z 플립5 팝니다',
//     product_name: '휴대폰',
//     images: ['https://picsum.photos/id/880/200/100'],
//     content: '미사용 새제품, 갤럭시 Z 플립5',
//     register_location: '서울시 종로구',
//     updated_at: '2024-03-15',
//     price: 1400000,
//     status: '새 상품',
//     seller_id: 'seller_003',
//     is_negotiable: true,
//     is_possible_meet_you: false,
//     category: '휴대폰',
//   ),
//   ProductInfoCard(
//     product_id: 4,
//     title: 'LG 울트라파인 5K 모니터',
//     product_name: '모니터',
//     images: ['https://picsum.photos/id/870/200/100'],
//     content: '새상품, 박스포장 그대로, 5K 모니터',
//     register_location: '경기도 성남시',
//     updated_at: '2024-04-10',
//     price: 1300000,
//     status: '새 상품',
//     seller_id: 'seller_004',
//     is_negotiable: false,
//     is_possible_meet_you: true,
//     category: '모니터',
//   ),
//   ProductInfoCard(
//     product_id: 5,
//     title: '소니 WH-1000XM5 헤드폰',
//     product_name: '휴대기기',
//     images: ['https://picsum.photos/id/860/200/100'],
//     content: '소니 WH-1000XM5, 사용감 약간, 박스포장 있음',
//     register_location: '서울시 마포구',
//     updated_at: '2024-05-05',
//     price: 400000,
//     status: '중고',
//     seller_id: 'seller_005',
//     is_negotiable: true,
//     is_possible_meet_you: false,
//     category: '헤드폰',
//   ),
//   ProductInfoCard(
//     product_id: 6,
//     title: '닌텐도 스위치 OLED 모델',
//     product_name: '게임기',
//     images: ['https://picsum.photos/id/900/200/100'],
//     content: '닌텐도 스위치 OLED 모델, 새상품',
//     register_location: '서울시 송파구',
//     updated_at: '2024-06-12',
//     price: 350000,
//     status: '새 상품',
//     seller_id: 'seller_006',
//     is_negotiable: true,
//     is_possible_meet_you: true,
//     category: '게임기',
//   ),
//   ProductInfoCard(
//     product_id: 7,
//     title: '애플 매직 키보드 풀사이즈',
//     product_name: '키보드',
//     images: ['https://picsum.photos/id/840/200/100'],
//     content: '애플 매직 키보드, 새상품, 풀사이즈',
//     register_location: '서울시 강서구',
//     updated_at: '2024-07-21',
//     price: 200000,
//     status: '새 상품',
//     seller_id: 'seller_007',
//     is_negotiable: false,
//     is_possible_meet_you: true,
//     category: '키보드',
//   ),
//   ProductInfoCard(
//     product_id: 8,
//     title: '한성 노트북 팝니다 (i7-12700H)',
//     product_name: '노트북',
//     images: ['https://picsum.photos/id/860/200/100'],
//     content: '한성 i7-12700H, 중고, 사용감 있음',
//     register_location: '대전광역시',
//     updated_at: '2024-08-19',
//     price: 800000,
//     status: '중고',
//     seller_id: 'seller_008',
//     is_negotiable: false,
//     is_possible_meet_you: false,
//     category: '노트북',
//   ),
//   ProductInfoCard(
//     product_id: 9,
//     title: '샤오미 공기청정기 미에어4',
//     product_name: '기타',
//     images: ['https://picsum.photos/id/880/200/100'],
//     content: '샤오미 미에어4 공기청정기, 새상품',
//     register_location: '경기도 고양시',
//     updated_at: '2024-09-25',
//     price: 180000,
//     status: '새 상품',
//     seller_id: 'seller_009',
//     is_negotiable: true,
//     is_possible_meet_you: false,
//     category: '가전',
//   ),
//   ProductInfoCard(
//     product_id: 10,
//     title: '캠핑용 접이식 의자 새상품',
//     product_name: '의자',
//     images: ['https://picsum.photos/id/870/200/100'],
//     content: '캠핑용 접이식 의자, 새상품, 무료배송',
//     register_location: '서울시 강북구',
//     updated_at: '2024-10-01',
//     price: 50000,
//     status: '새 상품',
//     seller_id: 'seller_010',
//     is_negotiable: true,
//     is_possible_meet_you: true,
//     category: '캠핑용품',
//   ),
// ];
