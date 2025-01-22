import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';

import 'selection_page.dart';

/*
  2025.01.21 - 이도영 : 상품등록 화면
*/
class ImageItem {
  final String path;
  final String id;

  ImageItem({required this.path, required this.id});
}

class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({super.key});

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final List<ImageItem> imagePaths = [];
  final int maxImages = 10;
  bool isNegotiable = false;
  String deliveryMethod = "불가능";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tradeLocationController = TextEditingController();

  String selectedCategory = "카테고리";
  String selectedBrand = "브랜드";

  final List<String> categories = ["카테고리", "휴대폰", "노트북", "컴퓨터", "테블릿", "웨어러블"];
  final List<String> brands = ["브랜드", "삼성", "애플", "LG", "기타"];
  void _selectCategory() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: categories,
          title: "카테고리",
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedCategory = selected;
      });
    }
  }

  // 브랜드 선택 함수
  void _selectBrand() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: brands,
          title: "브랜드",
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        selectedBrand = selected;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  void addImage() {
    if (imagePaths.length >= maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('최대 10개의 이미지만 추가할 수 있습니다.')),
      );
      return;
    }

    setState(() {
      if (imagePaths.length % 2 == 0) {
        imagePaths.add(ImageItem(
            path: 'assets/starbucks-logo.png',
            id: DateTime.now().millisecondsSinceEpoch.toString()));
      } else {
        imagePaths.add(ImageItem(
            path: 'assets/filedramon.jpg',
            id: DateTime.now().millisecondsSinceEpoch.toString()));
      }
    });
  }

  void removeImage(int index) {
    setState(() {
      imagePaths.removeAt(index);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    tradeLocationController.dispose();
    super.dispose();
  }

  Widget buildDropdown(
      String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null ||
            (items == categories && value == "카테고리") ||
            (items == brands && value == "브랜드")) {
          return '선택해주세요';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 물건 팔기'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 추가 및 출력 영역
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 사진 추가 버튼
                      GestureDetector(
                        onTap: addImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.add_a_photo, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 이미지 리스트
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: imagePaths.isNotEmpty
                              ? ReorderableListView(
                                  scrollDirection: Axis.horizontal,
                                  onReorder: (oldIndex, newIndex) {
                                    setState(() {
                                      if (newIndex > oldIndex) newIndex -= 1;
                                      final ImageItem movedItem =
                                          imagePaths.removeAt(oldIndex);
                                      imagePaths.insert(newIndex, movedItem);
                                    });
                                  },
                                  children: [
                                    for (int index = 0;
                                        index < imagePaths.length;
                                        index++)
                                      Stack(
                                        key: ValueKey(imagePaths[index].id),
                                        children: [
                                          // 이미지 출력
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 16),
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    imagePaths[index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          // "대표 사진" 레이블
                                          if (index == 0)
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                color: Colors.black54,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: const Text(
                                                  '대표 사진',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          // 삭제 버튼
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () => removeImage(index),
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Container(), // 이미지가 없을 때 빈 컨테이너
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 제목 입력
                  const Text('제목'),
                  TextFormField(
                    controller: titleController,
                    decoration: customInputDecoration('글 제목'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제목을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 카테고리 및 브랜드 선택
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _selectCategory,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedCategory),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _selectBrand,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedBrand),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 가격 입력
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: customInputDecoration('₩ 가격을 입력해주세요'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '가격을 입력해주세요';
                      }
                      if (int.tryParse(value) == null) {
                        return '유효한 숫자를 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: APlusTheme.spacingS),

                  // 가격 제안 받기
                  Row(
                    children: [
                      Checkbox(
                        value: isNegotiable,
                        onChanged: (value) {
                          setState(() {
                            isNegotiable = value ?? false;
                          });
                        },
                      ),
                      const Text('가격 제안 받기'),
                    ],
                  ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 거래 방식
                  const Text(
                    '거래 방식',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: APlusTheme.labelPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          value: "불가능",
                          groupValue: deliveryMethod,
                          onChanged: (value) {
                            setState(() {
                              deliveryMethod = value!;
                            });
                          },
                          title: const Text('불가능'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          value: "가능",
                          groupValue: deliveryMethod,
                          onChanged: (value) {
                            setState(() {
                              deliveryMethod = value!;
                            });
                          },
                          title: const Text('가능'),
                        ),
                      ),
                    ],
                  ),
                  if (deliveryMethod == "가능")
                    TextFormField(
                      controller: tradeLocationController,
                      decoration: customInputDecoration(
                        '직거래 장소를 입력해주세요',
                      ),
                      validator: (value) {
                        if (deliveryMethod == "가능" &&
                            (value == null || value.isEmpty)) {
                          return '직거래 장소를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 설명 입력
                  const Text('자재한 설명'),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: customInputDecoration(
                      '상품을 최대한 자세하게 설명해주세요',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '설명을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: APlusTheme.spacingM),

                  // 제출 버튼
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('제목: ${titleController.text}');
                        print('카테고리: $selectedCategory');
                        print('브랜드: $selectedBrand');
                        print('가격: ${priceController.text}');
                        print('가격 제안 받기: $isNegotiable');
                        print('거래 방식: $deliveryMethod');
                        if (deliveryMethod == "가능") {
                          print('직거래 장소: ${tradeLocationController.text}');
                        }
                        print('설명: ${descriptionController.text}');
                        // 추가적인 제출 로직 (예: 서버 전송 등)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('작성 완료'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration customInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: APlusTheme.borderLightGrey,
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: APlusTheme.borderLightGrey,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: APlusTheme.borderLightGrey,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ),
  );
}
