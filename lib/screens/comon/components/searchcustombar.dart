import 'package:flutter/material.dart';

/*
* 2025.01.21 - 이도영 : 검색창 분리
*
* */
class Searchcustombar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const Searchcustombar({
    Key? key,
    this.hintText = '검색어를 입력해주세요', // 기본 힌트 텍스트
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText, // 힌트 텍스트
        prefixIcon: const Icon(Icons.search, color: Colors.grey), // 검색 아이콘
        filled: true, // 배경 활성화
        fillColor: Colors.grey[100], // 회색 배경
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // 둥근 모서리
          borderSide: BorderSide.none, // 테두리 제거
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8), // 내부 여백
      ),
      style: const TextStyle(fontSize: 14), // 텍스트 스타일
    );
  }
}
