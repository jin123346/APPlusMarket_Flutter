import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../_core/size.dart';
import '../../../../_core/theme.dart';
import '../../../../services/api/login_api.dart';
import 'widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _uid = '';
  String _password = '';
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm(BuildContext context, WidgetRef ref) async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      print(
          '_uid ${_uidController.text}, _password ${_passwordController.text}');

      _uid = _uidController.text;
      _password = _passwordController.text;
      final apiService = ref.read(apiServiceProvider);
      final bool success = await apiService.login(_uid, _password);
      if (success) {
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('로그인 실패! 다시 시도하세요.')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                // TODO : Navigator 참조
                Navigator.pushNamed(context, '/home');
              },
              icon: Icon(Icons.arrow_back_ios)),
        ),
        resizeToAvoidBottomInset: false, // 키보드와 bottomNavigationBar 충돌 방지
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 화면 터치 시 키보드 닫기
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(commonPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 120),

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
                    formkey: _formkey,
                    uidController: _uidController,
                    passwordController: _passwordController,
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
                          onPressed: () {},
                          child: Text('아이디찾기')),
                      Container(height: 15, width: 1, color: Colors.grey),
                      TextButton(
                        onPressed: () {},
                        child: Text('비밀번호찾기'),
                        style: TextButton.styleFrom(
                            backgroundColor: APlusTheme.systemBackground,
                            foregroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10)),
                      ),
                      Container(height: 15, width: 1, color: Colors.grey),
                      TextButton(
                        onPressed: () {},
                        child: Text('회원가입'),
                        style: TextButton.styleFrom(
                            backgroundColor: APlusTheme.systemBackground,
                            foregroundColor: Colors.grey,
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(halfPadding),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => _submitForm(context, ref),
              child: const Text('로그인'),
            ),
          ),
        ),
      ),
    );
  }
}
