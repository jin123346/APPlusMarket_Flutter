import 'package:flutter/material.dart';
import 'login_form_field.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController uidController;
  final TextEditingController passwordController;

  LoginForm(
      {required this.formKey,
      required this.uidController,
      required this.passwordController,
      super.key});

  @override
  Widget build(BuildContext context) {
    String _uid = '';
    String _password = '';
    return Form(
      key: formKey,
      child: Column(
        children: [
          LoginFormField(
            label: '아이디',
            controller: uidController,
          ),
          SizedBox(height: 16),
          LoginFormField(
            label: '비밀번호',
            controller: passwordController,
            obsecure: true,
          ),
        ],
      ),
    );
  }
}
