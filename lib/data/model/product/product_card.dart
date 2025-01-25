/*
* 2025.01.21 - 황수빈 : ProductCard 모델링 클래스
*
*/

class ProductCard {
  final int product_id;
  final String name;
  final int price;
  final String thumbnail_image;
  final bool? is_negotiable; // 필수값 아님

  ProductCard(
      {required this.product_id,
      required this.name,
      required this.price,
      required this.thumbnail_image,
      this.is_negotiable});

  @override
  String toString() {
    return 'ProductCard{product_id: $product_id, name: $name, price: $price, thumbnail_image: $thumbnail_image, is_negotiable: $is_negotiable}';
  }
}

List<ProductCard> products = [
  ProductCard(
      is_negotiable: true,
      product_id: 1,
      name: '맥북 프로 14 2024년형 새상품 팝니다',
      price: 3000000,
      thumbnail_image: 'https://picsum.photos/id/910/200/100'),
  ProductCard(
      is_negotiable: false,
      product_id: 2,
      name: '아이패드 프로 11인치 4세대',
      price: 1200000,
      thumbnail_image: 'https://picsum.photos/id/890/200/100'),
  ProductCard(
      is_negotiable: true,
      product_id: 3,
      name: '삼성 갤럭시 Z 플립5 팝니다',
      price: 1400000,
      thumbnail_image: 'https://picsum.photos/id/880/200/100'),
  ProductCard(
      is_negotiable: false,
      product_id: 4,
      name: 'LG 울트라파인 5K 모니터',
      price: 1300000,
      thumbnail_image: 'https://picsum.photos/id/870/200/100'),
  ProductCard(
      is_negotiable: true,
      product_id: 5,
      name: '소니 WH-1000XM5 헤드폰',
      price: 400000,
      thumbnail_image: 'https://picsum.photos/id/860/200/100'),
  ProductCard(
      is_negotiable: true,
      product_id: 6,
      name: '닌텐도 스위치 OLED 모델',
      price: 350000,
      thumbnail_image: 'https://picsum.photos/id/900/200/100'),
  ProductCard(
      is_negotiable: true,
      product_id: 7,
      name: '애플 매직 키보드 풀사이즈',
      price: 200000,
      thumbnail_image: 'https://picsum.photos/id/840/200/100'),
  ProductCard(
      is_negotiable: false,
      product_id: 8,
      name: '한성 노트북 팝니다 (i7-12700H)',
      price: 800000,
      thumbnail_image: 'https://picsum.photos/id/860/200/100'),
  ProductCard(
      is_negotiable: false,
      product_id: 9,
      name: '샤오미 공기청정기 미에어4',
      price: 180000,
      thumbnail_image: 'https://picsum.photos/id/880/200/100'),
  ProductCard(
      is_negotiable: true,
      product_id: 10,
      name: '캠핑용 접이식 의자 새상품',
      price: 50000,
      thumbnail_image: 'https://picsum.photos/id/870/200/100'),
];
