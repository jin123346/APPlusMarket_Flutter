import 'package:applus_market/_core/size.dart';
import 'package:flutter/material.dart';

import '../../../_core/theme.dart';
import 'widgets/custom_textfield.dart';
import 'widgets/delivery_address_page.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({super.key});
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        actions: [
          InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/my/settings');
              },
              child: Icon(Icons.settings_outlined)),
          const SizedBox(width: 16)
        ],
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 35),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  '배송지 추가',
                  style: CustomTextTheme.headlineMedium,
                ),
                Text(
                  '* 배송지 정보를 입력해 주세요.',
                  style: CustomTextTheme.bodySmall,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(commonPadding),
              child: Column(
                children: [
                  CustomTextfield(
                      title: '배송지', textEditingController: textController),
                  const SizedBox(height: commonPadding),
                  CustomTextfield(
                      title: '받는사람이름', textEditingController: textController),
                  const SizedBox(height: commonPadding),
                  CustomTextfield(
                      title: '전화번호', textEditingController: textController),
                  const SizedBox(height: commonPadding),
                  CustomTextfield(
                      title: '휴대전화 번호', textEditingController: textController),
                  const SizedBox(height: commonPadding),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(height: 800, child: DeliveryAddressPage()),
            ),
          )
        ],
      ),
    ));
  }
}
