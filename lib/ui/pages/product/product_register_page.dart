import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import 'selection_page.dart';

/*
  2025.01.21 - 이도영 : 상품등록 화면
  2025.01.22 - 황수빈 : 상품등록 디자인 및 모듈 분리 작업
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
  bool isPossibleMeetYou = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tradeLocationController = TextEditingController();
  final TextEditingController productNameController = TextEditingController();

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
    SizedBox height16Box = const SizedBox(height: commonPadding);
    SizedBox height8Box = const SizedBox(height: halfPadding);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 물건 팔기'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pushNamed(context, '/home'),
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:
                              const Icon(Icons.add_a_photo, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 이미지 리스트
                      Expanded(
                        child: Container(
                          height: 90,
                          width: 90,

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
                                      Container(
                                        key: ValueKey(imagePaths[index].id),
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Stack(
                                          key: ValueKey(imagePaths[index].id),
                                          children: [
                                            // 이미지 출력
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      imagePaths[index].path),
                                                  fit: BoxFit.fill,
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
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3),
                                                  child: const Text(
                                                    '대표 사진',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  width: 18,
                                                  height: 18,
                                                  decoration:
                                                      const BoxDecoration(
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
                                      ),
                                  ],
                                )
                              : Container(), // 이미지가 없을 때 빈 컨테이너
                        ),
                      ),
                    ],
                  ),
                  height16Box,

                  // 제목 입력
                  _buildTitle('제목'),
                  height8Box,
                  _buildInputContainer(
                      controller: titleController, title: '글 제목'),
                  height16Box,

                  // 제품 입력
                  _buildTitle('제품'),
                  height8Box,
                  _buildInputContainer(
                      controller: productNameController, title: '제품명'),
                  height16Box,
                  // 카테고리 및 브랜드 선택

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('카테고리'),
                            height8Box,
                            GestureDetector(
                              onTap: _selectCategory,
                              child: Container(
                                height: 47,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: _defaultBoxDecoration(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedCategory,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: selectedCategory == '카테고리'
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('브랜드'),
                            height8Box,
                            GestureDetector(
                              onTap: _selectBrand,
                              child: Container(
                                height: 47,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: _defaultBoxDecoration(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedBrand,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: selectedBrand == '브랜드'
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  height16Box,
                  // 가격 입력

                  _buildTitle('가격'),
                  height8Box,
                  _buildInputContainer(
                      type: 'number', controller: priceController, title: '가격'),

                  const SizedBox(height: APlusTheme.spacingS),

                  // 가격 제안 받기
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          value: isNegotiable,
                          onChanged: (value) {
                            setState(() {
                              isNegotiable = value ?? false;
                            });
                          },
                          activeColor: Colors.red,
                          checkColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('가격 제안 받기'),
                    ],
                  ),
                  height16Box,
                  height8Box,
                  // 거래 방식

                  // 설명 입력
                  _buildTitle('자세한 설명'),
                  height8Box,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '상품에 대하여 자세히 설명해주세요.',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '설명을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  height16Box,
                  _buildTitle('직거래 '),

                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 30,
                      child: Radio<bool>(
                        value: false, // "불가능"
                        groupValue: isPossibleMeetYou,
                        onChanged: (value) {
                          setState(() {
                            isPossibleMeetYou = value!;
                          });
                        },
                      ),
                    ),
                    Text(
                      '불가능',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 5),
                    Radio<bool>(
                      value: true, // "가능"
                      groupValue: isPossibleMeetYou,
                      onChanged: (value) {
                        setState(() {
                          isPossibleMeetYou = value!;
                        });
                      },
                    ),
                    Text(
                      '가능',
                      style: TextStyle(fontSize: 16),
                    ),
                  ]),
                  height16Box,
                  height16Box,

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

_buildTitle(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
  );
}

_buildInputContainer({
  String type = 'text',
  required TextEditingController controller,
  required String title,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    decoration: _defaultBoxDecoration(),
    child: TextFormField(
      controller: controller,
      keyboardType:
          type == 'number' ? TextInputType.number : TextInputType.text,
      cursorColor: Colors.grey[600],
      cursorHeight: 20,
      decoration: InputDecoration(
        hintText: title == "제목" ? "글제목" : title,
        hintStyle: TextStyle(
            fontSize: 15, color: Colors.grey[500], fontWeight: FontWeight.w500),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 9),
      )
      ,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${title}을 입력해주세요';
        }
        if (title == "가격" && int.tryParse(value) == null) {
          return '유효한 숫자를 입력해주세요';
        }
        return null;
      },
    ),
  );
}

_defaultBoxDecoration() {
  return BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(10),
  );
}
