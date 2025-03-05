import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../_core/components/theme.dart';

/**
 * 2025.01.22 - 김민희 : PayMoneyCard 컴포넌트 화
 */

class PayMoneyCard extends StatelessWidget {
  final int balance;
  final VoidCallback onRefresh;
  final VoidCallback onCharge;
  final VoidCallback onTransfer;

  const PayMoneyCard({
    super.key,
    required this.balance,
    required this.onRefresh,
    required this.onCharge,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(APlusTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 애쁠머니 로고와 텍스트
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      size: 28,
                    ),
                    const SizedBox(width: APlusTheme.spacingS),
                    Text('애쁠머니', style: CustomTextTheme.titleMedium),
                  ],
                ),
                // 내 계좌 버튼
                Container(
                  decoration: BoxDecoration(
                    color: APlusTheme.tertiarySystemBackground,
                    borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: APlusTheme.spacingM,
                      vertical: APlusTheme.spacingS,
                    ),
                    child: Text('내 계좌', style: CustomTextTheme.bodyMedium),
                  ),
                ),
              ],
            ),
            const SizedBox(height: APlusTheme.spacingM),
            // 잔액 표시와 새로고침 버튼
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${balance}원',
                  style: CustomTextTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: onRefresh,
                ),
              ],
            ),
            const SizedBox(height: APlusTheme.spacingM),
            // 충전 및 송금 버튼
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCharge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APlusTheme.tertiarySystemBackground,
                      foregroundColor: APlusTheme.labelPrimary,
                    ),
                    child: const Text('충전'),
                  ),
                ),
                const SizedBox(width: APlusTheme.spacingS),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: APlusTheme.tertiarySystemBackground,
                      foregroundColor: APlusTheme.labelPrimary,
                    ),
                    child: const Text('송금'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
