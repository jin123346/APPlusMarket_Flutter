import 'package:applus_market/data/model/product/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/model_view/product/category_model_view.dart';
import 'package:flutter/material.dart';
/*
  2025.01.21 - 이도영 : 브랜드, 카테고리 선택 화면
*/

class SelectionPage extends StatelessWidget {
  final List<String> items; // 리스트 요소를 외부에서 전달받음
  final String title; // 페이지 제목을 외부에서 전달받음

  const SelectionPage({
    Key? key,
    required this.items,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: ListView(
        children: items.map((item) {
          return ListTile(
            title: Text(item),
            onTap: () {
              Navigator.pop(context, item); // 선택된 항목을 반환
            },
          );
        }).toList(),
      ),
    );
  }
}
