import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/auth/sign_up_state.dart';
import '../../../../../data/model/auth/signup_controller.dart';

class InsertPasswordPage extends ConsumerWidget {
  InsertPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SignUpController signUpNotifier =
        ref.read(SignUpControllerProvider.notifier);
    SignUpState signUpState = ref.watch(SignUpControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('회원정보 입력'),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Text(
                      '비밀번호를 입력하세요',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: signUpState.passwordController,
                      cursorColor: Colors.grey[600],
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        labelText: ' 비밀번호*',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: signUpState.confirmPasswordController,
                      cursorColor: Colors.grey[600],
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        labelText: ' 비밀번호 확인*',
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    const Spacer(), // 남은 공간을 채우기 위해 Spacer 추가
                  ],
                ),
              ),
              Positioned(
                bottom: 16, // 키보드 위로 버튼 위치
                left: 16,
                right: 16,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bool isValid = true;
                      if (signUpState.passwordController!.text.isNotEmpty) {
                        String? password = signUpNotifier.passwordValidation();
                        if (password != null) {
                          CustomSnackbar.showSnackBar(password);
                          isValid = false;
                        }
                      }
                      if (signUpState
                          .confirmPasswordController!.text.isNotEmpty) {
                        String? confirm =
                            signUpNotifier.confirmPasswordValidation();

                        if (confirm != null) {
                          CustomSnackbar.showSnackBar(confirm);
                          isValid = false;
                        } else {
                          isValid = true;
                        }
                      }

                      if (isValid &&
                          signUpState
                              .confirmPasswordController!.text.isNotEmpty &&
                          signUpState.passwordController!.text.isNotEmpty) {
                        Navigator.pushNamed(context, '/join/insertHp');
                      }
                    },
                    child: Text('다음'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
