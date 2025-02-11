import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/auth/login_state.dart';
import 'package:applus_market/data/model_view/user/my_address_vm.dart';
import 'package:applus_market/ui/pages/my/widgets/custom_two_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/size.dart';
import '../../../../_core/components/theme.dart';
import 'custom_textfield.dart';
import 'delivery_address_page.dart';

class DeliveryRegisterBody extends ConsumerStatefulWidget {
  DeliveryRegisterBody({super.key});

  @override
  ConsumerState<DeliveryRegisterBody> createState() =>
      _DeliveryRegisterBodyState();
}

class _DeliveryRegisterBodyState extends ConsumerState<DeliveryRegisterBody> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController postcodeController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    receiverController.dispose();
    phoneController.dispose();
    postcodeController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    messageController.dispose();
    isDefault = false;
    super.dispose();
  }

  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    SessionUser user = ref.watch(LoginProvider);

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
                    title: '배송지', textEditingController: titleController),
                const SizedBox(height: commonPadding),
                CustomTextfield(
                    title: '받는사람이름', textEditingController: receiverController),
                const SizedBox(height: commonPadding),
                CustomTextfield(
                    title: '휴대전화 번호', textEditingController: phoneController),
                const SizedBox(height: commonPadding),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
                height: 200,
                child: DeliveryAddressPage(postcodeController,
                    address1Controller, address2Controller)),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(commonPadding),
          sliver: SliverToBoxAdapter(
            child: Column(children: [
              CustomTextfield(
                  title: '배송 메세지  ', textEditingController: messageController),
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
                        setState(() {
                          isDefault = !isDefault;
                        });
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

                    ref.read(myAddressProvider.notifier).saveAddress(
                          userId: user.id,
                          title: titleController.text,
                          receiver: receiverController.text,
                          phone: phoneController.text,
                          postcode: postcodeController.text,
                          address1: address1Controller.text,
                          address2: address2Controller.text,
                          isDefault: isDefault,
                          message: messageController.text,
                        );
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
