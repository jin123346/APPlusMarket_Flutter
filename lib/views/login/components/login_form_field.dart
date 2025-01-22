import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';

class LoginFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  LoginFormField({required this.label, required this.controller, super.key});

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  late String _inputValue; // 상태 변수로 입력값을 저장
  late FocusNode _focusNode; // FocusNode 추가

  @override
  void initState() {
    super.initState();
    _inputValue = '';
    _focusNode = FocusNode(); // FocusNode 초기화
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.label == '비밀번호',
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: widget.label,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.label}를 입력하세요.';
        }
        return null;
      },
    );
  }
}
