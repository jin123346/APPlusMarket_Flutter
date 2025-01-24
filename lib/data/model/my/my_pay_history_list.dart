import 'package:intl/intl.dart';

/*
* 2025.01.22 - 김민희 : MyPayHistoryList 모델링 클래스
*/

class MyPayHistoryList {
  final int history_id; // 결제 기록 고유 식별자
  final String title; // 결제 건의 제목 (예: 상품명, 거래 내용 등)
  final String date; // 거래 발생 날짜 (형식: MM.DD)
  final int amount; // 거래 금액 (음수: 출금, 양수: 입금)
  final String type; // 거래 유형 (예: 송금, 충전 등)
  final String? icon_path; // 거래 관련 아이콘 이미지 경로 (optional)

  MyPayHistoryList({
    required this.history_id,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    this.icon_path,
  });

  // 금액에 화폐 단위 추가 (₩)
  String get formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'ko_KR', // 한국 형식
      symbol: '₩', // 원화 기호
    );
    return formatter.format(amount);
  }

  @override
  String toString() {
    return 'PayHistory{history_id: $history_id, title: $title, '
        'date: $date, amount: $amount, type: $type, icon_path: $icon_path}';
  }
}

List<MyPayHistoryList> pay_histories = [
  MyPayHistoryList(
    history_id: 1,
    title: '오버더바이크 공식 안장 판매',
    date: '09.28',
    amount: -10000,
    type: '송금',
    icon_path: 'assets/images/pay/transaction_1.png',
  ),
  MyPayHistoryList(
    history_id: 2,
    title: '기프트 1011',
    date: '09.28',
    amount: 10000,
    type: '충전',
    icon_path: 'assets/images/pay/transaction_2.png',
  ),
  MyPayHistoryList(
    history_id: 3,
    title: '9/13 금 사적 롯데한화 6:30',
    date: '09.13',
    amount: -60000,
    type: '송금',
    icon_path: 'assets/images/pay/transaction_3.png',
  ),
];
