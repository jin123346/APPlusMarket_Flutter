import 'package:applus_market/ui/pages/auth/login_page/widgets/login_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/auth/signup_controller.dart';

class InsertPasswordPage extends ConsumerWidget {
  InsertPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SignUpController signUpControllerNotifier =
        ref.read(SignUpControllerProvider.notifier);
    TextEditingController passwordController =
        signUpControllerNotifier.passwordController;
    TextEditingController confirmPasswordController =
        signUpControllerNotifier.confirmPasswordController;

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
                      controller: passwordController,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이름을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 확인해주세요 ';
                        }
                        return null;
                      },
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
                      Navigator.pushNamed(context, '/join/insertHp');
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
