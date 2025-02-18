import 'package:flutter/material.dart';

import '../../../../_core/components/size.dart';

class CustomLabelInputField extends StatelessWidget {
  final String title;
  final String inputLabel;
  final TextEditingController controller;
  final String type;

  const CustomLabelInputField(
      {this.type = 'text',
      required this.title,
      required this.controller,
      required this.inputLabel,
      super.key});
  BoxDecoration _defaultBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: halfPadding),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: _defaultBoxDecoration(),
          child: TextFormField(
            controller: controller,
            keyboardType:
                type == 'number' ? TextInputType.number : TextInputType.text,
            cursorColor: Colors.grey[600],
            cursorHeight: 20,
            decoration: InputDecoration(
              hintText: inputLabel,
              hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500),
              border: const UnderlineInputBorder(borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 9),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$title 을 입력해주세요';
              }
              if (title == "가격" && int.tryParse(value) == null) {
                return '유효한 숫자를 입력해주세요';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
