import 'package:applus_market/_core/theme.dart';
import 'package:applus_market/ui/pages/auth/login_page/widgets/login_form_field.dart';
import 'package:applus_market/ui/widgets/applus_text_logo.dart';
import 'package:flutter/material.dart';

class JoinCheckPage extends StatelessWidget {
  JoinCheckPage({super.key});

  final TextEditingController uidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    APPlusTextLogo(
                      size: 40,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'uidController.text님\n환영합니다.',
                      style: CustomTextTheme.titleLarge,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: uidController,
                      cursorColor: Colors.grey[600],
                      cursorHeight: 20,
                      decoration: InputDecoration(
                        labelText: ' 아이디*',
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
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

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
                      Navigator.pushNamed(context, '/login');
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
