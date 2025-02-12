/*
   2025.02.09 하진희 나의배송지 정보 view model 
 */

import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../model/my/my_address.dart';
import '../../repository/auth/address_respository.dart';

class MyAddressVM extends Notifier<List<MyAddress>> {
  final addressRepository = const AddressRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  List<MyAddress> build() {
    // TODO: implement build
    return [];
  }

  // 나의 주소 목록

  Future<void> getMyAddresses(int userId) async {
    try {
      if (userId == 0) {
        return CustomSnackbar.showSnackBar('조회할 user가 없음');
      }

      Map<String, dynamic> resBody =
          await addressRepository.findMyAddress(userId);
      logger.i('resBody!! $resBody');
      if (resBody['status'] == 'failed') {
        return CustomSnackbar.showSnackBar(resBody['message']);
      }

      logger.i('조회성공!! ');
      List<dynamic> data = resBody['data'];

      state = data.map((e) => MyAddress.fromJson(e)).toList();
      logger.i(state);
      return;
    } catch (e, stackTrace) {
      logger.w(e);
      ExceptionHandler.handleException('주소 조회 중 에러 발생', stackTrace);
    }
  }

  Future<void>? saveAddress(
      {int? userId,
      String? title,
      String? receiver,
      String? phone,
      String? postcode,
      String? address1,
      String? address2,
      bool? isDefault,
      String? message}) async {
    try {
      if (userId == 0 ||
          title == null ||
          receiver == null ||
          phone == null ||
          postcode == null ||
          address1 == null ||
          address2 == null ||
          isDefault == null ||
          message == null) {
        CustomSnackbar.showSnackBar('정보를 빠짐없이 입력해주세요.');
        return;
      }

      if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
        CustomSnackbar.showSnackBar('휴대폰 번호는 10~11자리 숫자여야 합니다.');
        return;
      }

      Map<String, dynamic> body = {
        "userId": userId,
        "title": title,
        "receiverName": receiver,
        "receiverPhone": phone,
        "postcode": postcode,
        "address1": address1,
        "address2": address2,
        "isDefault": isDefault,
        "message": message,
      };

      Map<String, dynamic> resBody = await addressRepository.saveAddress(body);
      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar(resBody['message']);
        return;
      }

      state = [
        ...state,
        MyAddress(
            userId: userId,
            isDefault: isDefault,
            postcode: postcode,
            address1: address1,
            address2: address2,
            message: message,
            title: title,
            receiverName: receiver,
            receiverPhone: phone)
      ];

      DialogHelper.showAlertDialog(
          context: mContext,
          title: '배송지 등록이 완료되었습니다.',
          onConfirm: () {
            Navigator.pop(mContext);
          });
      Navigator.popAndPushNamed(mContext, '/my/delivery');

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('배송지 등록 중 오류 ', stackTrace);
    }
  }

  Future<void>? modifyAddress(
      {int? id,
      int? userId,
      String? title,
      String? receiver,
      String? phone,
      String? postcode,
      String? address1,
      String? address2,
      bool? isDefault,
      String? message}) async {
    try {
      if (userId == 0 ||
          title == null ||
          receiver == null ||
          phone == null ||
          postcode == null ||
          address1 == null ||
          address2 == null ||
          isDefault == null ||
          message == null) {
        CustomSnackbar.showSnackBar('정보를 빠짐없이 입력해주세요.');
        return;
      }

      if (!RegExp(r'^\d{10,11}$').hasMatch(phone)) {
        CustomSnackbar.showSnackBar('휴대폰 번호는 10~11자리 숫자여야 합니다.');
        return;
      }

      Map<String, dynamic> body = {
        "id": id,
        "userId": userId,
        "title": title,
        "receiverName": receiver,
        "receiverPhone": phone,
        "postcode": postcode,
        "address1": address1,
        "address2": address2,
        "isDefault": isDefault,
        "message": message,
      };
      logger.e('보낼 값 : $body');
      Map<String, dynamic> resBody =
          await addressRepository.modifyAddress(body);
      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar(resBody['message']);
        return;
      }

      state = state.map((address) {
        if (address.id == id) {
          // ID가 일치하는 기존 항목을 업데이트
          return MyAddress(
            id: id,
            userId: userId,
            isDefault: isDefault,
            postcode: postcode,
            address1: address1,
            address2: address2,
            message: message,
            title: title,
            receiverName: receiver,
            receiverPhone: phone,
          );
        }
        return address; // 기존 데이터 유지
      }).toList();

// 🔥 만약 해당 id가 기존 state에 없다면, 새로운 주소 추가
      if (!state.any((address) => address.id == id)) {
        state = [
          ...state,
          MyAddress(
            id: id,
            userId: userId,
            isDefault: isDefault,
            postcode: postcode,
            address1: address1,
            address2: address2,
            message: message,
            title: title,
            receiverName: receiver,
            receiverPhone: phone,
          )
        ];
      }

      DialogHelper.showAlertDialog(
          context: mContext,
          title: '배송지 수정이 완료되었습니다.',
          onConfirm: () {
            Navigator.pushNamedAndRemoveUntil(
                mContext, '/my/delivery', (route) => false);
          });

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('배송지 등록 중 오류 ', stackTrace);
    }
  }

  Future<void>? deleteAddress(int userId, int addressId) async {
    try {
      if (userId == 0 || addressId == 0) {
        CustomSnackbar.showSnackBar('삭제 중 오류');
        return;
      }

      Map<String, dynamic> resBody =
          await addressRepository.deleteAddress(userId, addressId);
      if (resBody['status'] == 'failed') {
        CustomSnackbar.showSnackBar(resBody['message']);
        return;
      }

      // ✅ 기존 state를 변경할 수 없으므로 새로운 리스트 생성
      state = List.from(state)
        ..removeWhere((element) => element.id == addressId);
      DialogHelper.showAlertDialog(
        context: mContext,
        title: '배송지 삭제가 완료되었습니다.',
        onConfirm: () {
          Navigator.pop(mContext);
        },
      );
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('배송지 삭제 중 오류 ', stackTrace);
    }
  }
}

final myAddressProvider = NotifierProvider<MyAddressVM, List<MyAddress>>(
  () => MyAddressVM(),
);

String formatPhoneNumber(String phone) {
  final RegExp regExp = RegExp(r'(\d{3})(\d{4})(\d{4})');
  return phone.replaceAllMapped(regExp, (Match m) => '${m[1]}-${m[2]}-${m[3]}');
}
