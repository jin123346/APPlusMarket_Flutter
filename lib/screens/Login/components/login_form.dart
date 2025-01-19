import 'package:applus_market/screens/Login/components/login_form_field.dart';
import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formkey;
  final TextEditingController uidController;
  final TextEditingController passwordController;

  LoginForm(
      {required this.formkey,
      required this.uidController,
      required this.passwordController,
      super.key});

  @override
  Widget build(BuildContext context) {
    String _uid = '';
    String _password = '';
    return Form(
      key: formkey,
      child: Column(
        children: [
          LoginFormField(
            label: '아이디',
            controller: uidController,
          ),
          LoginFormField(
            label: '비밀번호',
            controller: passwordController,
          ),
        ],
      ),
    );
  }
}
