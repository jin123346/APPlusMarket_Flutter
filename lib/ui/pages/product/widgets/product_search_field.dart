import 'dart:async';

import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/size.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../data/model_view/product/product_search_notifier.dart';

class ProductSearchField extends ConsumerStatefulWidget {
  final TextEditingController controller;
  const ProductSearchField({Key? key, required this.controller})
      : super(key: key);

  @override
  ConsumerState<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends ConsumerState<ProductSearchField> {
  Timer? _debounce;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(productSearchProvider.notifier).searchProducts(query);
    });
  }

  void _showOverlay() {
    _hideOverlay(); // 기존 Overlay 제거

    // `RenderBox`를 사용하여 `TextField`의 위치를 가져오기
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double textFieldHeight = renderBox.size.height;
    _overlayEntry = _createOverlayEntry(offset, textFieldHeight);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(Offset offset, double textFieldHeight) {
    final productList = ref.watch(productSearchProvider);
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + textFieldHeight + 8, // TextField 바로 아래에 위치
        width: MediaQuery.of(context).size.width * 0.9,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 250, // 최대 높이 제한 (overflow 시 스크롤)
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productList[index].name ?? "이름 없음"),
                  onTap: () {
                    widget.controller.text = productList[index].name ?? "";
                    ref
                        .read(productSearchProvider.notifier)
                        .updateCurrentSelected(productList[index]);
                    _hideOverlay();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  BoxDecoration _defaultBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: commonPadding),
          Text(
            '제품 검색',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: halfPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: _defaultBoxDecoration(),
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.text,
                    focusNode: _focusNode,
                    cursorColor: Colors.grey[600],
                    cursorHeight: 20,
                    onChanged: (query) {
                      _onSearchChanged(query);
                    },
                    decoration: InputDecoration(
                      hintText: '제품명, 제품 코드 검색',
                      hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: OutlinedButton(
                  onPressed: () {
                    if (widget.controller.text == null) {
                      CustomSnackbar.showSnackBar('키워드를 입력하세요');
                      return;
                    }

                    logger.i('검색할 단어 : ${widget.controller.text}');
                    ref
                        .read(productSearchProvider.notifier)
                        .searchProducts(widget.controller.text.trim());
                    _showOverlay();
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Text('검색'),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    side: BorderSide(color: Colors.grey.shade300, width: 0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
