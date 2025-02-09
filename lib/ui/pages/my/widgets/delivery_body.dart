import 'package:applus_market/data/gvm/session_gvm.dart';
import 'package:applus_market/data/model/my/my_address.dart';
import 'package:applus_market/data/model_view/user/my_address_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../_core/components/theme.dart';
import '../../../../_core/utils/custom_snackbar.dart';
import '../../../../_core/utils/logger.dart';
import '../../../../data/model/auth/login_state.dart';
import 'custom_two_button.dart';

class DeliveryBody extends ConsumerStatefulWidget {
  const DeliveryBody({super.key});

  @override
  ConsumerState<DeliveryBody> createState() => _DeliveryBodyState();
}

class _DeliveryBodyState extends ConsumerState<DeliveryBody> {
  bool isSelected = false;
  List<MyAddress> addresses = [];
  bool isExist = false;
  int? selectIndex;
  int? userId;

  @override
  void initState() {
    _getAddress();
    super.initState();
  }

  void _getAddress() async {
    SessionUser sessionUser = ref.read(LoginProvider);
    if (sessionUser == null || sessionUser.id == 0) {
      return;
    }
    userId = sessionUser.id;
    await ref.read(myAddressProvider.notifier).getMyAddresses(sessionUser.id!);
    List<MyAddress> myAddresses = ref.watch(myAddressProvider);
    if (myAddresses.isEmpty) {
      return;
    }

    setState(() {
      isExist = true;
      addresses.addAll(myAddresses);
    });

    logger.i('셋팅된 address ${addresses[0].toString()}');
  }

  @override
  Widget build(BuildContext context) {
    List<MyAddress> addresses = ref.watch(myAddressProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '배송지 관리',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '* 주문시 기본 배송지로 자동 설정됩니다.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Visibility(
                visible: isExist,
                child: Column(
                  children: List.generate(
                    addresses.length,
                    (index) => addressContainer(addresses[index], index),
                  ),
                )),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                    visible: !isExist, child: Text('등록된 배송지가 없습니다.\n추가해주세요.')),
                ElevatedButton(
                  onPressed: () {
                    // 배송지 추가 기능
                    Navigator.pushNamed(context, '/my/delivery/register');
                  },
                  child: Text(
                    '배송지 추가',
                    style: CustomTextTheme.bodyMedium,
                  ),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 16),
            CustomTwoButton(
              button1: '배송지 삭제',
              button2: '배송지 수정',
              button1Function: () {
                if (selectIndex == null || selectIndex! >= addresses.length) {
                  CustomSnackbar.showSnackBar('삭제할 배송지가 선택되지 않았거나 존재하지 않습니다.');
                  return;
                }

                ref
                    .read(myAddressProvider.notifier)
                    .deleteAddress(userId!, addresses[selectIndex!].id!);
                setState(() {
                  if (addresses.length == 0) {
                    isExist = false;
                  }
                });
              },
              button2Function: () {
                //배송지 insert 로직 추가
                if (selectIndex == null || selectIndex! >= addresses.length) {
                  CustomSnackbar.showSnackBar('수정할 배송지가 선택되지 않았거나 존재하지 않습니다.');
                  return;
                }
                logger.i('선택된 번호 : $selectIndex');
                Navigator.pushNamed(context, '/my/delivery/modify',
                    arguments: addresses[selectIndex!]);
              },
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget addressContainer(MyAddress myAddress, int index) {
    String phone = formatPhoneNumber(myAddress.receiverPhone!);
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade500)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: (selectIndex == index),
              groupValue: true,
              onChanged: (value) {
                logger.i('선택된 번호 : $selectIndex');
                setState(() {
                  selectIndex = index;
                });
              },
              activeColor: Colors.black,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (myAddress.isDefault == false)
                          ? '[ ${myAddress.title} ]'
                          : '[ 기본배송지/${myAddress.title} ]',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${myAddress.receiverName}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${myAddress.receiverPhone} / $phone',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1, // 최대 줄 수 제한 설정
                      '${myAddress.address1} ${myAddress.address2}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
