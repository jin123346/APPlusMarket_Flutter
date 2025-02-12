import 'package:applus_market/data/model/product/category.dart';
import 'package:applus_market/data/model_view/product/categrory_model_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/*
  2025.01.21 - 이도영 : 브랜드, 카테고리 선택 화면
*/

class SelectionPage extends ConsumerStatefulWidget {
  final List<String>? items; // 리스트 요소를 외부에서 전달받음
  final String title; // 페이지 제목을 외부에서 전달받음

  const SelectionPage({
    Key? key,
    this.items,
    required this.title,
  }) : super(key: key);

  @override
  ConsumerState<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends ConsumerState<SelectionPage> {
  @override
  void initState() {
    if (widget.title == '브랜드') {
      CategoryVM categoryVM = ref.read(categoryProvider.notifier);
      categoryVM.getAllCategory();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} 선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기
          },
        ),
      ),
      body: (widget.title == '브랜드')
          ? ListView(
              children: widget.items!.map((item) {
              return ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.pop(context, item); // 선택된 항목을 반환
                },
              );
            }).toList())
          : ListView(
              children: List.generate(
                categories.length,
                (index) {
                  Category category = categories[index];
                  return ExpansionTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero), // 경계선 제거
                    tilePadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

                    title: Text(
                      '${category.categoryName}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    visualDensity: VisualDensity.compact, // 간격 최소화

                    childrenPadding: EdgeInsets.only(left: 5),
                    children: category.subCategory != null &&
                            category.subCategory!.isNotEmpty
                        ? category.subCategory!
                            .map(
                              (subCategory) => ListTile(
                                title: Text('-  ${subCategory.categoryName!}'),
                                onTap: () {
                                  Navigator.pop(
                                      context, subCategory.categoryName);
                                },
                              ),
                            )
                            .toList()
                        : [const ListTile(title: Text("하위 카테고리가 없습니다."))],
                  );
                },
              ),
            ),
    );
  }
}
//
