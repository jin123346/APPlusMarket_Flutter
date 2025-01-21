/*
*
* 2025.01.21 - 황수빈 : /chatting 에서 리스트 이용하기 위해 class 생성
*/

// 채팅 리스트에서 사용 - /chatting

class ChatRoomCard {
  final int chat_room_id;
  final String product_thumbnail;
  final int product_id;
  final bool isSeller; // 채팅방의 제품 판매자
  final String user_image;
  final String user_name;
  final String recent_message;
  final String message_created_at;

  ChatRoomCard(
      {required this.chat_room_id,
      required this.product_thumbnail,
      required this.product_id,
      required this.user_image,
      required this.isSeller,
      required this.user_name,
      required this.recent_message,
      required this.message_created_at});
}

List<ChatRoomCard> chatRoomCards = [
  ChatRoomCard(
    chat_room_id: 1,
    user_image: 'https://picsum.photos/id/900/200/100',
    user_name: '멋쟁이상점',
    isSeller: true,
    recent_message: '안녕하세요? 혹시 네고 가능할까요 ?',
    message_created_at: '2025-01-21 10:30:00',
    product_thumbnail: 'https://picsum.photos/id/910/200/100',
    product_id: 1,
  ),
  ChatRoomCard(
    chat_room_id: 2,
    product_thumbnail: 'https://picsum.photos/id/910/200/100',
    product_id: 1,
    user_image: 'https://picsum.photos/id/860/200/100',
    user_name: '이쁜이상점',
    isSeller: true,
    recent_message: '혹시 얼마나 입으신 상품인가요?',
    message_created_at: '2025-01-20 15:45:00',
  ),
  ChatRoomCard(
    chat_room_id: 3,
    product_thumbnail:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    product_id: 2, // Unsplash에서 가져온 썸네일 이미지
    user_image: 'https://picsum.photos/id/870/200/100',
    user_name: '맥북구매자',
    isSeller: false,
    recent_message: '싸이클 수가 어떻게 되죠?',
    message_created_at: '2025-01-19 13:00:00',
  ),
  ChatRoomCard(
    chat_room_id: 4,
    product_thumbnail:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    product_id: 2, // Unsplash에서 가져온 썸네일 이미지
    user_image: 'https://picsum.photos/id/880/200/100',
    user_name: '멋쟁이사자처럼',
    isSeller: true,
    recent_message: '혹시 직거래 어디서 가능하세요? 저는 서면역 15번 출구를 원합니다',
    message_created_at: '2025-01-18 09:15:00',
  ),
  ChatRoomCard(
    chat_room_id: 5,
    product_thumbnail:
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    product_id: 2, // Unsplash에서 가져온 썸네일 이미지
    user_image: 'https://picsum.photos/id/890/200/100',
    user_name: '나는야멋쟁',
    isSeller: true,
    recent_message: '3000원 가능하세요?',
    message_created_at: '2025-01-17 18:00:00',
  ),
];
