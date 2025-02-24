import 'dart:io';
import 'package:applus_market/data/gvm/geo/location_gvm.dart';
import 'package:applus_market/data/gvm/product/product_gvm.dart';
import 'package:applus_market/data/model_view/product/image_item_view_model.dart';
import 'package:applus_market/data/model_view/product/product_search_notifier.dart';
import 'package:applus_market/ui/pages/product/widgets/custom_label_input_field.dart';
import 'package:applus_market/ui/pages/product/widgets/image_select_container.dart';
import 'package:applus_market/ui/pages/product/widgets/product_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../_core/components/size.dart';
import '../../../../_core/utils/apiUrl.dart';
import '../../../../data/gvm/session_gvm.dart';
import '../../../../data/model/auth/login_state.dart';
import '../../../../data/model/product/product.dart';
import '../../../../data/model_view/product/product_modify_view_model.dart';
import '../selection_page.dart';
import '../../../../_core/components/theme.dart';
import 'product_register_body.dart';

class ProductModifyBody extends ConsumerStatefulWidget {
  final int productId;

  const ProductModifyBody({required this.productId, Key? key})
      : super(key: key);

  @override
  ConsumerState<ProductModifyBody> createState() => _ProductRegisterBodyState();
}

class _ProductRegisterBodyState extends ConsumerState<ProductModifyBody> {
  // 컨트롤러들을 상태로 선언 (상품을 등록한 뒤에 초기화 하기 위함)
  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController tradeLocationController;
  late final TextEditingController productNameController;
  late final TextEditingController productFindController;
  bool isNegotiable = false;
  bool isPossibleMeetYou = false;
  String selectedCategory = "";
  String selectedBrand = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product? product;
  bool isLoading = true;

  @override
  void initState() {
    product = null;
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    tradeLocationController = TextEditingController();
    productNameController = TextEditingController();
    productFindController = TextEditingController();

    super.initState();
    _initProduct();
  }

  Future<void> _initProduct() async {
    setState(() {
      product = null; // 기존 데이터 초기화
      isLoading = true;
    });

    await ref
        .read(productModifyProvider.notifier)
        .selectModifyProduct(widget.productId);
    if (!mounted) return;
    product = ref.read(productModifyProvider);

    if (product != null) {
      _updateControllers();
      _setExistingImages();
    }

    setState(() {
      isLoading = false; // 데이터 로딩 완료
    });
  }

  void _updateControllers() {
    titleController.text = product?.title ?? "";
    priceController.text = product?.price?.toString() ?? "";
    productNameController.text = product?.productName ?? "";
    productFindController.text = product?.findProduct?.name ?? "";
    descriptionController.text = product?.content ?? "";
    isNegotiable = product?.isNegotiable ?? false;
    isPossibleMeetYou = product?.isPossibleMeetYou ?? false;
    selectedCategory = product?.category ?? "";
    selectedBrand = product?.brand ?? "";
    setState(() {}); // 🔹 UI 강제 업데이트
  }

  void _setExistingImages() {
    if (product!.images != null && product!.images!.isNotEmpty) {
      final existingImages = product!.images!
          .map((image) => ImageItem(
                path:
                    "$apiUrl/uploads/${product!.id!}/${image.uuidName}", // 기존 이미지 경로
                id: image.id.toString(),
                sequence: image.sequence!, // 이미지 ID (DB 삭제 처리 가능)
              ))
          .toList();

      ref.read(imageStateProvider.notifier).state = existingImages;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    tradeLocationController.dispose();
    productNameController.dispose();
    productFindController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final productSearchNotifier = ref.read(productSearchProvider.notifier);
    final imageState = ref.watch(imageStateProvider); // 이미지 상태 가져오기

    final SizedBox height16Box = const SizedBox(height: commonPadding);
    final SizedBox height8Box = const SizedBox(height: halfPadding);
    SessionUser sessionUser = ref.watch(LoginProvider);
    int userid = sessionUser.id!;
    product = ref.watch(productModifyProvider);
    return (isLoading)
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('내 물건 수정하기'),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 이미지 추가 및 출력 영역
                        ImageSelectContainer(),
                        height16Box,
                        // 제목 입력
                        CustomLabelInputField(
                            title: '제목',
                            controller: titleController,
                            inputLabel: '글 제목'),
                        height16Box,
                        // 제품 입력
                        CustomLabelInputField(
                            title: '제품',
                            controller: productNameController,
                            inputLabel: '제품명'),
                        height16Box,
                        // 카테고리 및 브랜드 선택
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
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
                            const SizedBox(width: 16),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
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
                          ],
                        ),

                        Visibility(
                          visible: selectedBrand == '삼성',
                          child: ProductSearchField(
                              controller: productFindController),

                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     height16Box,
                          //     CustomLabelInputField(
                          //         title: '제품 검색하기',
                          //         controller: productFindController,
                          //         inputLabel: '제품명, 제품 코드'),
                          //   ],
                          // ),
                        ),

                        height16Box,
                        // 가격 입력
                        CustomLabelInputField(
                            title: '가격',
                            type: 'number',
                            controller: priceController,
                            inputLabel: '가격'),
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
                                  ref
                                      .read(isNegotiableProvider.notifier)
                                      .state = value ?? false;
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
                        _buildTitle('택배 가능 여부'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Radio<bool>(
                                value: false,
                                groupValue: isPossibleMeetYou,
                                onChanged: (value) {
                                  ref
                                      .read(isPossibleMeetYouProvider.notifier)
                                      .state = value!;
                                },
                              ),
                            ),
                            const Text('가능', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 5),
                            Radio<bool>(
                              value: true,
                              groupValue: isPossibleMeetYou,
                              onChanged: (value) {
                                ref
                                    .read(isPossibleMeetYouProvider.notifier)
                                    .state = value!;
                              },
                            ),
                            const Text('불가능', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        height16Box,
                        height16Box,
                        // 제출 버튼
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // Provider에 저장된 ImageItem 리스트를 File 객체 리스트로 변환
                              final List<File> imageFiles = imageState
                                  .map((img) => File(img.path))
                                  .toList();
                              // 현재 "서울" 위치기반 API 를 활용해서 상세 주소로 변경 해야합니다.
                              await ref
                                  .read(productModifyProvider.notifier)
                                  .modifyProduct(
                                    id: product!.id!,
                                    title: titleController.text,
                                    productName: productNameController.text,
                                    content: descriptionController.text,
                                    price: priceController.text,
                                    isNegotiable: isNegotiable,
                                    isPossibleMeetYou: isPossibleMeetYou,
                                    category: selectedCategory,
                                    brand: selectedBrand,
                                    findProduct:
                                        productFindController.text ?? "",
                                    images: product!.images,
                                  );

                              // 등록 성공 후 입력 데이터 초기화
                              titleController.clear();
                              productNameController.clear();
                              priceController.clear();
                              descriptionController.clear();
                              tradeLocationController.clear();
                              productFindController.clear();

                              productSearchNotifier.reset();

                              // 이미지 목록 초기화
                              ref.read(imageStateProvider.notifier).reset();
                              // 선택된 카테고리, 브랜드도 초기값으로 설정 (필요한 경우)
                              ref
                                  .read(selectedCategoryProvider.notifier)
                                  .state = "카테고리";
                              ref.read(selectedBrandProvider.notifier).state =
                                  "브랜드";
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('수정 하기'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }
}
