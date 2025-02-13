import 'package:flutter/material.dart';

import '../../../../../../_core/utils/logger.dart';

class ChargeCompletePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('👏 충전 완료 ChargeCompletePage() ');

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Icon(
                Icons.check_circle,
                color: Colors.deepOrange,
                size: 60,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                '김민희님\n1,000원이 충전되었습니다',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // *** [수정] 송금 상세 정보 -> 충전 상세 정보
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildInfoRow('충전 계좌', '기업 01057843378'),
                  _buildInfoRow('수수료', '0원 (무료 4회 남음)'),
                ],
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      // *** [수정] 로그 메시지 변경
                      logger.i('🍎 충전 완료 → 버튼 클릭 이벤트 발생');
                      // 버튼 클릭 처리
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF3B30),
                      // primary: Colors.deepOrange,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('확인'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value),
        ],
      ),
    );
  }
}
