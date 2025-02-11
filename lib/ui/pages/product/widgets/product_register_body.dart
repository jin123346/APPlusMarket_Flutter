import 'dart:io';
import 'package:applus_market/data/gvm/product/product_gvm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../_core/components/size.dart';
import '../../../../_core/utils/apiUrl.dart';
import '../../../../data/gvm/session_gvm.dart';
import '../../../../data/model/auth/login_state.dart';
import '../selection_page.dart';
import '../../../../_core/components/theme.dart';

// 이미지 항목 클래스
class ImageItem {
  final String path;
  final String id;
  ImageItem({required this.path, required this.id});
}

// 각 상태를 위한 StateProvider 선언
final imagePathsProvider = StateProvider<List<ImageItem>>((ref) => []);
final isNegotiableProvider = StateProvider<bool>((ref) => false);
final isPossibleMeetYouProvider = StateProvider<bool>((ref) => false);
final selectedCategoryProvider = StateProvider<String>((ref) => "카테고리");
final selectedBrandProvider = StateProvider<String>((ref) => "브랜드");

class ProductRegisterBody extends ConsumerStatefulWidget {
  const ProductRegisterBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductRegisterBody> createState() =>
      _ProductRegisterBodyState();
}

class _ProductRegisterBodyState extends ConsumerState<ProductRegisterBody> {
  // 컨트롤러들을 상태로 선언 (상품을 등록한 뒤에 초기화 하기 위함)
  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController tradeLocationController;
  late final TextEditingController productNameController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    tradeLocationController = TextEditingController();
    productNameController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    tradeLocationController.dispose();
    productNameController.dispose();
    super.dispose();
  }

  // 이미지 추가 함수 (이미지 피커 사용)
  Future<void> addImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final current = ref.read(imagePathsProvider.notifier).state;
      if (current.length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('최대 10개의 이미지만 추가할 수 있습니다.')),
        );
        return;
      }
      final newImage = ImageItem(
        path: pickedFile.path,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      ref.read(imagePathsProvider.notifier).state = [...current, newImage];
    }
  }

  // 이미지 제거 함수
  void removeImage(int index) {
    final current = ref.read(imagePathsProvider.notifier).state;
    final updated = List<ImageItem>.from(current)..removeAt(index);
    ref.read(imagePathsProvider.notifier).state = updated;
  }

  // 카테고리 선택 함수
  Future<void> _selectCategory() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: ["카테고리", "휴대폰", "노트북", "컴퓨터", "테블릿", "웨어러블"],
          title: "카테고리",
        ),
      ),
    );
    if (selected != null) {
      ref.read(selectedCategoryProvider.notifier).state = selected;
    }
  }

  // 브랜드 선택 함수
  Future<void> _selectBrand() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: ["브랜드", "삼성", "애플", "LG", "기타"],
          title: "브랜드",
        ),
      ),
    );
    if (selected != null) {
      ref.read(selectedBrandProvider.notifier).state = selected;
    }
  }

  // 기본 박스 데코레이션
  BoxDecoration _defaultBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    );
  }

  // 제목 텍스트 위젯
  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  // 입력 컨테이너 위젯
  Widget _buildInputContainer({
    String type = 'text',
    required TextEditingController controller,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = ref.watch(imagePathsProvider);
    final isNegotiable = ref.watch(isNegotiableProvider);
    final isPossibleMeetYou = ref.watch(isPossibleMeetYouProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedBrand = ref.watch(selectedBrandProvider);
    final SizedBox height16Box = const SizedBox(height: commonPadding);
    final SizedBox height8Box = const SizedBox(height: halfPadding);
    SessionUser sessionUser = ref.watch(LoginProvider);
    int userid = sessionUser.id!;
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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 추가 및 출력 영역
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Expanded(
                        child: Container(
                          height: 90,
                          child: imagePaths.isNotEmpty
                              ? ReorderableListView(
                                  scrollDirection: Axis.horizontal,
                                  onReorder: (oldIndex, newIndex) {
                                    final List<ImageItem> items =
                                        List.from(imagePaths);
                                    if (newIndex > oldIndex) newIndex -= 1;
                                    final item = items.removeAt(oldIndex);
                                    items.insert(newIndex, item);
                                    ref
                                        .read(imagePathsProvider.notifier)
                                        .state = items;
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
                                          children: [
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: FileImage(File(
                                                      imagePaths[index].path)),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            //위치가 첫번째 이면 대표 사진으로 지정
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
                                                  child: const Icon(Icons.close,
                                                      color: Colors.white,
                                                      size: 16),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              : Container(),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                      const SizedBox(width: 16),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
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
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          value: isNegotiable,
                          onChanged: (value) {
                            ref.read(isNegotiableProvider.notifier).state =
                                value ?? false;
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
                  // 자세한 설명 입력
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
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 13),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Radio<bool>(
                          value: false,
                          groupValue: isPossibleMeetYou,
                          onChanged: (value) {
                            ref.read(isPossibleMeetYouProvider.notifier).state =
                                value!;
                          },
                        ),
                      ),
                      const Text('불가능', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 5),
                      Radio<bool>(
                        value: true,
                        groupValue: isPossibleMeetYou,
                        onChanged: (value) {
                          ref.read(isPossibleMeetYouProvider.notifier).state =
                              value!;
                        },
                      ),
                      const Text('가능', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  height16Box,
                  height16Box,
                  // 제출 버튼
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Provider에 저장된 ImageItem 리스트를 File 객체 리스트로 변환
                        final List<File> imageFiles =
                            imagePaths.map((img) => File(img.path)).toList();
                        // 현재 "서울" 위치기반 API 를 활용해서 상세 주소로 변경 해야합니다.
                        await ref.read(productProvider.notifier).insertproduct(
                              titleController.text, // 제목
                              productNameController.text, // 제품명
                              descriptionController.text, // 내용 (설명)
                              "서울", // registerLocation
                              env!, // registerIp
                              int.parse(priceController.text), // 가격
                              isNegotiable, // 가격 제안 받기 여부
                              isPossibleMeetYou, // 직거래 가능 여부
                              selectedCategory, // 카테고리
                              userid,
                              imageFiles, // 이미지 파일 리스트
                            );
                        // 등록 성공 후 입력 데이터 초기화
                        titleController.clear();
                        productNameController.clear();
                        priceController.clear();
                        descriptionController.clear();
                        tradeLocationController.clear();

                        // 이미지 목록 초기화
                        ref.read(imagePathsProvider.notifier).state = [];

                        // 선택된 카테고리, 브랜드도 초기값으로 설정 (필요한 경우)
                        ref.read(selectedCategoryProvider.notifier).state =
                            "카테고리";
                        ref.read(selectedBrandProvider.notifier).state = "브랜드";
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
