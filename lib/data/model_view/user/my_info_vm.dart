import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/auth/user.dart';
import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../../main.dart';

class MyInfoVM extends Notifier<User> {
  final AuthRepository authRepository = AuthRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  User build() {
    return User(
      id: null,
      password: null,
      birthday: null,
      uid: null,
      name: null,
      nickName: null,
      email: null,
      hp: null,
    );
  }

  // myPage 정보 요청하기
  Future<void> getMyInfo() async {
    try {
      Map<String, dynamic> resBody = await authRepository.getMyInfo();
      if (resBody['status'] == 'failed') {
        String message = resBody['message'];
        ExceptionHandler.handleException('message', StackTrace.current);
        return;
      }

      Map<String, dynamic> data = resBody['data'];
      state = state.copyWith(
        id: data['id'],
        name: data['name'],
        uid: data['uid'],
        nickName: data['nickName'],
        birthday: DateTime.parse(data['birthDay']),
        hp: data['hp'],
        email: data['email'],
      );

      return;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('User 조회시 오류 발생', stackTrace);
    }
  }

  Future<void> updateMyInfo(
      {required String? email,
      required String? nickName,
      required String? hp}) async {
    try {
      Map<String, dynamic> body = {
        "id": state.id,
        "email": email ?? state.email,
        "nickName": nickName ?? state.nickName,
        "hp": hp ?? state.hp,
      };
      Map<String, dynamic> resBody = await authRepository.updateMyInfo(body);

      logger.i(resBody);
      if (resBody['status'] == 'failed') {
        ExceptionHandler.handleException(
            resBody['message'], StackTrace.current);
        return;
      }

      DialogHelper.showAlertDialog(context: mContext, title: '업데이트 성공');
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('회원업데이트시 오류 발생', stackTrace);
    }
  }

  void updateNickName(String name) {
    state = state.copyWith(nickName: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateHp(String hp) {
    state = state.copyWith(hp: hp);
  }
}

final myInfoProvider = NotifierProvider<MyInfoVM, User>(
  () {
    return MyInfoVM();
  },
);
