import 'package:applus_market/data/model/product/product_my_list.dart';
import 'package:applus_market/ui/pages/my/widgets/product_hidden_list.dart';
import 'package:applus_market/ui/pages/my/widgets/product_sell_completed_list.dart';
import 'package:applus_market/ui/pages/my/widgets/product_sell_list.dart';
import 'package:applus_market/ui/pages/my/widgets/profile_image_container.dart';
import 'package:flutter/material.dart';

class MySellListBody extends StatefulWidget {
  const MySellListBody({super.key});

  @override
  State<MySellListBody> createState() => _MySellListBodyState();
}

class _MySellListBodyState extends State<MySellListBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 판매내역',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  // "글쓰기" 버튼
                  Align(
                    alignment: Alignment.topCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/product/register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[200],
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('판매 등록'),
                    ),
                  ),
                ],
              ),
              ProfileImageContainer(),
            ],
          ),
        ),

        // 탭바 (판매중 / 거래완료 / 숨김)
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: '판매중'),
            Tab(text: '거래완료'),
            Tab(text: '숨김'),
          ],
        ),

        // 탭바 컨텐츠
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ProductSellList(
                status: "Active",
              ),
              ProductSellCompletedList(),
              ProductHiddenList(),
              // 판매중 탭
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyContent() {
    return const Center(
      child: Text(
        '게시글이 없어요.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
