import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/auth/user.dart';
import 'package:applus_market/data/repository/auth/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';

class MyInfoVM extends Notifier<User> {
  final AuthRepository authRepository = AuthRepository();
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
      if (resBody['status'] == 'fail') {
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
}

final myInfoProvider = NotifierProvider<MyInfoVM, User>(
  () {
    return MyInfoVM();
  },
);
