import 'package:applus_market/ui/pages/my/widgets/custom_two_button.dart';
import 'package:flutter/material.dart';

import '../../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import 'custom_textfield.dart';
import 'delivery_address_page.dart';

class DeliveryBody extends StatelessWidget {
  DeliveryBody({super.key});
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isDefault = true;

    return CustomScrollView(
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
            child: SizedBox(height: 200, child: DeliveryAddressPage()),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(commonPadding),
          sliver: SliverToBoxAdapter(
            child: Column(children: [
              CustomTextfield(
                  title: '배송 메세지  ', textEditingController: textController),
            ]),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(commonPadding),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Checkbox(
                      value: isDefault,
                      onChanged: (value) {
                        isDefault = !isDefault;
                      },
                    ),
                    Text(
                      '기본 배송지 설정하기',
                      style: CustomTextTheme.bodyMedium,
                    ),
                  ],
                ),
                CustomTwoButton(
                  button1: '취소',
                  button2: '추가하기',
                  button1Function: () {},
                  button2Function: () {
                    //배송지 insert 로직 추가
                    Navigator.pushNamed(context, '/my/delivery');
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
