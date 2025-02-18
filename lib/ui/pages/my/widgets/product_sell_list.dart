import 'package:applus_market/_core/components/theme.dart';
import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/data/model/product/product_my_list.dart';
import 'package:applus_market/ui/pages/components/time_ago.dart';
import 'package:applus_market/ui/pages/my/my_sell_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../_core/utils/priceFormatting.dart';
import '../../../../data/model_view/product/product_my_list_model_view.dart';

class ProductSellList extends ConsumerStatefulWidget {
  final String status;
  const ProductSellList({required this.status, super.key});

  @override
  ConsumerState<ProductSellList> createState() => _ProductSellListState();
}

class _ProductSellListState extends ConsumerState<ProductSellList> {
  List<ProductMyList> mySellList = [];
  bool _isLoading = true;
  bool _isExist = true;
  @override
  void initState() {
    _loadList();
    super.initState();
  }

  void _loadList() async {
    await ref
        .read(productMyLisProvider.notifier)
        .getMyOnSaleList(null, widget.status);
  }

  @override
  Widget build(BuildContext context) {
    List<ProductMyList> mySellList = ref.watch(productMyLisProvider);
    if (mySellList.isEmpty) {
      setState(() {
        _isExist = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isExist = true;
        _isLoading = false;
      });
    }

    return (_isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              height: 300,
              child: ListView(
                  children: (_isExist)
                      ? List.generate(
                          mySellList.length,
                          (index) {
                            ProductMyList product = mySellList[index];
                            String time = timeAgo(product.createdAt!);
                            String price = formatPrice(product.price!);
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                SizedBox(
                                    child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.network(
                                        "$apiUrl/uploads/${product.id}/${product.uuidName}",
                                        width: 140,
                                        height: 150,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${product.productName}',
                                          style: CustomTextTheme.titleMedium,
                                        ),
                                        Text(
                                            '${product.registerLocation} ${time} '),
                                        Text(
                                          '${price} 원',
                                          style: CustomTextTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '판매중',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 5,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (!canReload(product.reloadAt)) {
                                              return;
                                            }
                                            DialogHelper.showAlertDialog(
                                                context: context,
                                                title: '끌어올리시겠습니까?',
                                                onConfirm: () {
                                                  Navigator.pop(
                                                      context); // 다이얼로그 닫기
                                                  _updateReload(
                                                      productId: product.id!);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                isCanceled: true);
                                          },
                                          child: Text('끌어올리기'),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  canReload(product.reloadAt)
                                                      ? Colors.white12
                                                      : Colors.grey.shade200,
                                              foregroundColor:
                                                  canReload(product.reloadAt)
                                                      ? Colors.black
                                                      : Colors.grey,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25),
                                              side: BorderSide(
                                                  color: Colors.grey.shade500)),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: IconButton(
                                          onPressed: () {
                                            _showProductOptions(
                                                context, product);
                                          },
                                          icon: Icon(Icons.more_vert)),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        )
                      : [
                          ListTile(
                            title: Text("현재 판매중인 상품이 없습니다."),
                          )
                        ]),
            ),
          );
  }

  void _showProductOptions(BuildContext context, ProductMyList product) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(context, '예약중', () {
                Navigator.pop(context);
                _updateStatus(
                    productId: product.id!,
                    status: 'Reserved',
                    message: '예약중처리 되었습니다.');
              }),
              _buildOption(context, '거래완료', () {
                Navigator.pop(context);
                _updateStatus(
                    productId: product.id!,
                    status: 'Sold',
                    message: '거래완료 처리되었습니다.');
              }),
              _buildOption(context, '게시글 수정', () {
                Navigator.pushNamed(context, '/product/modify',
                    arguments: product.id);
              }),
              _buildOption(context, '숨기기', () {
                Navigator.pop(context);
                _updateStatus(
                    productId: product.id!,
                    status: 'Hidden',
                    message: '숨김 처리 되었습니다.');
              }),
              Divider(),
              _buildOption(context, '삭제', () {
                Navigator.pop(context);
                _deleteProduct(product.id!);
              }, isDelete: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(BuildContext context, String title, VoidCallback onTap,
      {bool isDelete = false}) {
    return ListTile(
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isDelete ? Colors.red : Colors.black,
            fontWeight: isDelete ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  //삭제기능
  void _deleteProduct(int productId) async {
    // await ref.read(productMyLisProvider.notifier).deleteProduct(productId);
  }

// 끌어올리기
  void _updateReload({required int productId}) async {
    FocusScope.of(context).unfocus();
    await ref.read(productMyLisProvider.notifier).updateReload(productId);
  }

  bool canReload(String? reloadAt) {
    if (reloadAt == null || reloadAt.isEmpty) return true; // reloadAt이 없으면 허용
    try {
      // "2025-02-17T12:40:13" 형식을 지원하도록 파싱
      DateTime reloadDate = DateTime.parse(reloadAt);
      DateTime now = DateTime.now();
      return now.difference(reloadDate).inDays >= 3; // 3일 이상 지났는지 확인
    } catch (e) {
      print("⚠️ Date Parsing Error: $e"); // 디버깅 로그 추가
      return true; // 에러 발생 시 기본적으로 허용
    }
  }

  void _updateStatus(
      {required int productId,
      required String status,
      required message}) async {
    await ref
        .read(productMyLisProvider.notifier)
        .updateStatus(productId, status, message);
  }
// 받은 후기 보기
// 후기 보내기
}
