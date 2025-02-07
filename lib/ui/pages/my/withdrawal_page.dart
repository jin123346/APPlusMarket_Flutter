import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/ui/widgets/applus_text_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model/auth/login_state.dart';
import '../../widgets/applus_pay_text_logo.dart';
import 'widgets/withdrawal_confirmation_dialog.dart';

class WithdrawalPage extends ConsumerWidget {
  const WithdrawalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionUser sessionUser = ref.watch(LoginProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('탈퇴하기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${sessionUser.nickname}님, 계정을 삭제하기 위해서는 아래 내용의 확인이 필요해요.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => _showWithdrawalConfirmation(context),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Applus Pay 가입 여부',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Applus Pay 서비스를 먼저 해지해 주세요.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawalConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => WithdrawalConfirmationDialog(),
    );
  }
}
