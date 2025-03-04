import 'package:flutter/material.dart';

class ProductSearchBar extends StatelessWidget {
  final TextEditingController textEditingController;
  final void Function(String) onSubmitted;
  ProductSearchBar(
      {required this.textEditingController,
      required this.onSubmitted,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: TextField(
        controller: textEditingController,
        cursorColor: Colors.grey,
        onSubmitted: (query) {
          print(" 검색어 입력됨: $query"); // 디버깅용 로그 추가
          onSubmitted(query);
        },
        decoration: InputDecoration(
          hintText: '검색어를 입력해주세요',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black54,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
