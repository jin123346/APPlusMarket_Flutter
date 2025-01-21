import 'package:applus_market/theme.dart';
import 'package:flutter/material.dart';

class ProductRegisterPage extends StatefulWidget {
  const ProductRegisterPage({super.key});

  @override
  State<ProductRegisterPage> createState() => _ProductRegisterPageState();
}

class _ProductRegisterPageState extends State<ProductRegisterPage> {
  final List<String> imagePaths = []; // 추가된 이미지 경로를 저장
  bool isNegotiable = false; // 가격 제안 받기 여부
  String deliveryMethod = "택배"; // 직거래 방식 (택배 or 직거래)
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tradeLocationController = TextEditingController();

  String selectedCategory = "의류"; // 기본값
  String selectedBrand = "Nike"; // 기본값

  final List<String> categories = ["의류", "전자기기", "가구", "도서", "기타"];
  final List<String> brands = ["Nike", "Adidas", "GUCCI", "ZARA", "H&M"];

  void addImage() {
    // 이미지 추가 로직 (예: 파일 선택)
    setState(() {
      imagePaths.add("sample_image_path"); // 임시 이미지 경로 추가
    });
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
        body: Padding(
          padding: const EdgeInsets.all(APlusTheme.spacingM),
          child: ListView(
            children: [
              // 사진 추가 영역
              Row(
                children: [
                  GestureDetector(
                    onTap: addImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: APlusTheme.tertiaryColor,
                        borderRadius: BorderRadius.circular(APlusTheme.radiusM),
                      ),
                      child: const Icon(Icons.add_a_photo,
                          color: APlusTheme.labelTertiary),
                    ),
                  ),
                  const SizedBox(width: APlusTheme.spacingM),
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagePaths.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: APlusTheme.spacingS),
                            child: Image.asset(
                              imagePaths[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: APlusTheme.spacingM),

              // 제목 입력 필드
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                ),
              ),
              const SizedBox(height: APlusTheme.spacingM),

              // 카테고리와 브랜드 선택 (한 줄에 배치)
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '카테고리',
                      ),
                    ),
                  ),
                  const SizedBox(width: APlusTheme.spacingM),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedBrand,
                      items: brands.map((brand) {
                        return DropdownMenuItem<String>(
                          value: brand,
                          child: Text(brand),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedBrand = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: '브랜드',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: APlusTheme.spacingM),

              // 가격 입력 필드
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '₩ 가격을 입력해주세요',
                ),
              ),
              const SizedBox(height: APlusTheme.spacingS),

              // 가격 제안 받기 체크박스
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

              // 직거래 방식 라디오 버튼
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
                      value: "택배",
                      groupValue: deliveryMethod,
                      onChanged: (value) {
                        setState(() {
                          deliveryMethod = value!;
                        });
                      },
                      title: const Text('택배'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      value: "직거래",
                      groupValue: deliveryMethod,
                      onChanged: (value) {
                        setState(() {
                          deliveryMethod = value!;
                        });
                      },
                      title: const Text('직거래'),
                    ),
                  ),
                ],
              ),
              if (deliveryMethod == "직거래")
                TextField(
                  controller: tradeLocationController,
                  decoration: const InputDecoration(
                    labelText: '직거래 장소를 입력해주세요',
                  ),
                ),
              const SizedBox(height: APlusTheme.spacingM),

              // 상세 설명 필드
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: '자세한 설명',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: APlusTheme.spacingM),

              // 작성 완료 버튼
              ElevatedButton(
                onPressed: () {
                  print('제목: ${titleController.text}');
                  print('카테고리: $selectedCategory');
                  print('브랜드: $selectedBrand');
                  print('가격: ${priceController.text}');
                  print('가격 제안 받기: $isNegotiable');
                  print('거래 방식: $deliveryMethod');
                  if (deliveryMethod == "직거래") {
                    print('직거래 장소: ${tradeLocationController.text}');
                  }
                  print('설명: ${descriptionController.text}');
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
    );
  }
}
