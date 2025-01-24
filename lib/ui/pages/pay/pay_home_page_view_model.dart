// // lib/view_models/my_pay_view_model.dart
//
// import 'package:flutter/material.dart';
// import '../../models/my/my_pay_history_list.dart';
//
// /**
//  * 2025.01.22 - 김민희 : MyPay 뷰모델 클래스
//  * 결제 관련 상태 및 비즈니스 로직을 관리합니다.
//  */
// class MyPayViewModel extends ChangeNotifier {
//   // 결제 기록 목록을 관리하는 상태 변수
//   List<MyPayHistoryList> _payHistoryList = myPayHistoryList;
//
//   // 현재 잔액을 관리하는 상태 변수
//   int _balance = 0;
//
//   // 로딩 상태를 관리하는 변수
//   bool _isLoading = false;
//
//   // Getter 메서드들
//   List<MyPayHistoryList> get payHistoryList => _payHistoryList;
//   int get balance => _balance;
//   bool get isLoading => _isLoading;
//
//   /**
//    * 송금 기능
//    * @param amount 송금할 금액
//    * @param receiverName 받는 사람 이름
//    */
//   Future<void> sendMoney(int amount, String receiverName) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // 잔액 확인
//       if (_balance < amount) {
//         throw Exception('잔액이 부족합니다');
//       }
//
//       // 새로운 거래 내역 추가
//       final newHistory = MyPayHistoryList(
//         history_id: _payHistoryList.length + 1,
//         title: '$receiverName에게 송금',
//         date: _getCurrentDate(),
//         amount: -amount, // 송금은 음수로 처리
//         type: '송금',
//         icon_path: 'assets/images/pay/send_money.png',
//       );
//
//       _payHistoryList.insert(0, newHistory); // 최신 거래를 맨 앞에 추가
//       _balance -= amount; // 잔액 차감
//
//       notifyListeners();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /**
//    * 충전 기능
//    * @param amount 충전할 금액
//    */
//   Future<void> chargeMoney(int amount) async {
//     try {
//       _isLoading = true;
//       notifyListeners();
//
//       // 새로운 거래 내역 추가
//       final newHistory = MyPayHistoryList(
//         history_id: _payHistoryList.length + 1,
//         title: '충전',
//         date: _getCurrentDate(),
//         amount: amount, // 충전은 양수로 처리
//         type: '충전',
//         icon_path: 'assets/images/pay/charge_money.png',
//       );
//
//       _payHistoryList.insert(0, newHistory); // 최신 거래를 맨 앞에 추가
//       _balance += amount; // 잔액 증가
//
//       notifyListeners();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   /**
//    * 현재 날짜를 MM.dd 형식의 문자열로 반환
//    */
//   String _getCurrentDate() {
//     final now = DateTime.now();
//     return '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
//   }
//
//   /**
//    * 거래 내역 필터링
//    * @param type 거래 유형 (송금, 충전)
//    * @returns 필터링된 거래 내역 목록
//    */
//   List<MyPayHistoryList> getHistoryByType(String type) {
//     return _payHistoryList.where((history) => history.type == type).toList();
//   }
//
//   /**
//    * 거래 내역 초기화 (테스트용)
//    */
//   void resetHistory() {
//     _payHistoryList = [];
//     _balance = 0;
//     notifyListeners();
//   }
// }
