import 'package:applus_market/ui/pages/pay/widgets/pay_transaction_item.dart';
import 'package:flutter/material.dart';

import '../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';

import '../../../_core/utils/logger.dart';
import 'widgets/pay_money_card.dart';
import 'widgets/pay_send_page.dart';

class PayHomePage extends StatelessWidget {
  const PayHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: APlusTheme.tertiarySystemBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(APlusTheme.spacingM),
        children: [
          // 1. 애쁠머니
          PayMoneyCard(
            // 잔액
            balance: 0,
            // 🔁 초기화 아이콘
            onRefresh: () {},
            // 충전 - chargePage
            onCharge: () {
              logger.i('충전 버튼');
              Navigator.pushNamed(context, '/pay/charge');
            },
            // 송금
            // 송금 버튼 클릭시 iOS 스타일 전환 애니메이션 적용
            onTransfer: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PaySendPage(), // 송금 페이지 이동
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                        position: offsetAnimation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
          const SizedBox(height: APlusTheme.spacingM),
          // 2. 애쁠 체크카드 출시
          _buildCheckCardBanner(),
          const SizedBox(height: APlusTheme.spacingM),
          // 최근 이용내역
          _buildRecentTransactions(),
          const SizedBox(height: APlusTheme.spacingM),
          // 이 달의 좋은 혜택
          _buildPromotionBanner(),
        ],
      ),
    );
  }

  // 당근 체크카드 출시
  Widget _buildCheckCardBanner() {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(APlusTheme.spacingM),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: APlusTheme.lightRed,
            borderRadius: BorderRadius.circular(APlusTheme.radiusS),
          ),
          child: Icon(Icons.credit_card, color: APlusTheme.primaryColor),
        ),
        title: const Text('애쁠 체크카드 출시'),
        subtitle: const Text('월 최대 3만원 적립해 주는 실리왕 카드'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  // 최근 이용내역
// 최근 이용내역
  Widget _buildRecentTransactions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(APlusTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀 위에 텍스트 추가
            Row(
              children: [
                Text('최근 이용내역', style: CustomTextTheme.titleMedium),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: iconList,
                ),
              ],
            ),
            PayTransactionItem(
              title: '맥 미니',
              date: '03.07',
              type: '송금',
              amount: -10000,
            ),
            PayTransactionItem(
              title: '10,000 충전',
              date: '02.10',
              type: '충전',
              amount: 10000,
            ),
            PayTransactionItem(
              title: '갤럭시 스마트태그2',
              date: '12.31',
              type: '송금',
              amount: -5000,
              showBorder: false,
            ),
          ],
        ),
      ),
    );
  } // end of _buildRecentTransactions

  // 프로모션 배너
  Widget _buildPromotionBanner() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(APlusTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타이틀 위에 텍스트 추가
            Text('이 달의 좋은 혜택', style: CustomTextTheme.titleMedium),
            // const SizedBox(height: 8), // 간격 추가
            ListTile(
              contentPadding: EdgeInsets.zero, // 기본 패딩 제거

              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: APlusTheme.infoColor.withOpacity(0.1), // 배경색 + 투명도 10%
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 30, // 아이콘 크기 조정 해야함
                  color: APlusTheme.infoColor,
                ),
              ),

              title: const Text(
                'KB 다이렉트 자동차보험 이벤트',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                '차 보험료 계산시 스벅 아아 2잔, 30...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              trailing: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: 60,
                  height: 35,
                  color: APlusTheme.tertiaryColor,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: APlusTheme.primaryColor, // 텍스트 색상
                    ),
                    child: Text(
                      '받기',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              onTap: () {
                print('이 달의 좋은 혜택 클릭 ❗(콜백함수)');
              },
            ),
          ],
        ),
      ),
    );
  }
}
