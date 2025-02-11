import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../_core/components/size.dart';
import '../../../../../_core/components/theme.dart';
import 'login_form.dart';

class LoginBody extends ConsumerWidget {
  GlobalKey<FormState> formKey; // ✅ 추가
  final TextEditingController uidController;
  final TextEditingController passwordController;
  LoginBody({required this.formKey,required this.uidController,required this.passwordController, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SessionGVM loginNotifier = ref.read(LoginProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(commonPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),

              Stack(
                children: [
                  Container(
                    width: getParentWith(context),
                    height: 85,
                    child: Text(
                      'APPLUS',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bangers(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: APlusTheme.primaryColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      width: getParentWith(context),
                      child: Text(
                        textAlign: TextAlign.center,
                        'Smart Choices for Smarter Devices.',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              // Logo(),
              const SizedBox(height: 20),
              LoginForm(
                formKey: formKey,
                uidController: uidController,
                passwordController: passwordController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: APlusTheme.systemBackground,
                          foregroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/find_id');
                      },
                      child: Text('아이디찾기')),
                  Container(height: 15, width: 1, color: Colors.grey),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/find_pass');
                    },
                    child: Text('비밀번호찾기'),
                    style: TextButton.styleFrom(
                        backgroundColor: APlusTheme.systemBackground,
                        foregroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
                  ),
                  Container(height: 15, width: 1, color: Colors.grey),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/join');
                    },
                    child: Text('회원가입'),
                    style: TextButton.styleFrom(
                        backgroundColor: APlusTheme.systemBackground,
                        foregroundColor: Colors.grey,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 10)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
