import 'package:applus_market/_core/utils/apiUrl.dart';
import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model/product/product_my_list.dart';
import 'package:applus_market/ui/pages/components/time_ago.dart';
import 'package:applus_market/ui/pages/my/my_sell_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/utils/priceFormatting.dart';
import '../../../../data/model_view/product/product_my_list_model_view.dart';

class ProductSellCompletedList extends ConsumerStatefulWidget {
  const ProductSellCompletedList({super.key});

  @override
  ConsumerState<ProductSellCompletedList> createState() =>
      _ProductSellListState();
}

class _ProductSellListState extends ConsumerState<ProductSellCompletedList> {
  List<ProductMyList> mySellList = [];
  bool _isLoading = true;
  bool _isExist = true;
  @override
  void initState() {
    _loadList();
    super.initState();
  }

  void _loadList() async {
    await ref.read(productMyLisProvider.notifier).getMyCompletedList(null);
  }

  @override
  Widget build(BuildContext context) {
    SessionUser user = ref.watch(LoginProvider);
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
                  children: (mySellList.length != 0)
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
                                        Text('${product.productName}'),
                                        Text(
                                            '${product.registerLocation} ${time} '),
                                        Text('${price} 원'),
                                        const SizedBox(height: 5),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '거래완료',
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
                                          onPressed: () {},
                                          child: Text(
                                              (product.sellerId == user.id)
                                                  ? '받은후기보기'
                                                  : '후기 보내기'),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white12,
                                              foregroundColor: Colors.black,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 25),
                                              side: BorderSide(
                                                  color: Colors.black)),
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
                          Center(
                            child: Text("현재 판매중인 상품이 없습니다."),
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
              _buildOption(context, '판매중', () {
                Navigator.pop(context);
                _updateStatus(
                    productId: product.id!,
                    status: 'Sold',
                    message: '판매 중으로 변경되었습니다.');
              }),
              _buildOption(context, '게시글 수정', () {
                Navigator.pop(context);
                // 수정 페이지로 이동하는 로직 추가
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

  void _updateStatus(
      {required int productId,
      required String status,
      required String message}) async {
    await ref
        .read(productMyLisProvider.notifier)
        .updateStatus(productId, status, message);
  }
}
