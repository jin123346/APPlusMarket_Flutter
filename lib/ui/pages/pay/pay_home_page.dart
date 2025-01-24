import 'package:flutter/material.dart';

import '../../../_core/size.dart';
import '../../../_core/theme.dart';
import 'widget/pay_money_card.dart';
import 'widget/pay_transaction_item.dart';


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
            balance: 0,
            onRefresh: () {},
            onCharge: () {},
            onTransfer: () {},
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
  Widget _buildRecentTransactions() {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('최근 이용내역', style: CustomTextTheme.titleMedium),
              Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: iconList,
                ),
              ),
            ],
          ),
          const SizedBox(height: APlusTheme.spacingM),
          PayTransactionItem(
            title: '오버디바이크 공식 안장 판매합..',
            date: '09.28',
            type: '승인',
            amount: -10000,
          ),
          PayTransactionItem(
            title: '기업 1011',
            date: '09.28',
            type: '충전',
            amount: 10000,
          ),
          PayTransactionItem(
            title: '9/13 금 롯데한화 6:30',
            date: '09.13',
            type: '송금',
            amount: -60000,
          ),
        ],
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
