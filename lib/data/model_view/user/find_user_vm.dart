import 'package:applus_market/_core/utils/custom_snackbar.dart';
import 'package:applus_market/_core/utils/dialog_helper.dart';
import 'package:applus_market/_core/utils/exception_handler.dart';
import 'package:applus_market/data/model/auth/find_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_core/utils/logger.dart';
import '../../../main.dart';
import '../../repository/auth/auth_repository.dart';

class FindUserVm extends Notifier<FindUserState> {
  final AuthRepository authRepository = AuthRepository();
  final mContext = navigatorkey.currentContext!;

  @override
  FindUserState build() {
    return FindUserState(
      email: "",
    );
  }

  Future<bool> findUserUid(String? name, String? email) async {
    try {
      if (name == null || email == null) {
        ExceptionHandler.handleException('정보를 입력해주세요', StackTrace.current);
        return false;
      }
      Map<String, dynamic> body = {
        "name": name.trim(),
        "email": email.trim(),
      };

      Map<String, dynamic> resBody =
          await authRepository.findUidByNameAndEmail(body);

      if (resBody['status'] == 'failed') {
        String message = resBody['message'];
        return false;
      }

      Map<String, dynamic> user = resBody['data'];

      state = state.copyWith(
        uid: maskedUid(user['uid']),
      );
      return true;
    } catch (e, stackTrace) {
      logger.e('find User uid 찾기 오류' + e.toString());
      ExceptionHandler.handleException('e ${e}', stackTrace);
      return false;
    }
  }

  String maskedUid(String uid) {
    int halfLength = uid.length ~/ 2; // 길이의 절반
    String maskedPart = '*' * (uid.length - halfLength - 1); // 나머지 부분을 '*'로 표시
    String visiblePart = uid.substring(0, halfLength + 1); // 앞부분은 그대로 표시
    return visiblePart + maskedPart;
  }

  Future<bool> findUserPass(String? uid, String? email) async {
    try {
      if (uid == null || email == null) {
        CustomSnackbar.showSnackBar('모든 정보를 입력하세요');
        return false;
      }
      Map<String, dynamic> body = {
        'uid': uid,
        'email': email,
      };
      Map<String, dynamic> resBody =
          await authRepository.findPassByUidAndEmail(body);

      if (resBody['status'] == 'failed') {
        DialogHelper.showAlertDialog(
            context: mContext, title: resBody['message']);
        return false;
      }
      Map<String, dynamic> user = resBody['data'];
      logger.i('user!!!! $user');
      state = state.copyWith(
        id: user['id'],
      );

      logger.i('비밀번호 찾기 요청 성공 : ${state.id}');
      return true;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('비밀번호 찾기 통신 오류', stackTrace);
      return false;
    }
  }

  Future<bool> chagePassword(String pass, String confirmPass) async {
    try {
      if (pass != confirmPass) {
        CustomSnackbar.showSnackBar('비밀번호가 일치하지 않습니다.');
        return false;
      }
      Map<String, dynamic> body = {
        'id': state.id,
        'password': pass,
      };
      Map<String, dynamic> resBody = await authRepository.changePass(body);
      if (resBody['status'] == 'failed') {
        DialogHelper.showAlertDialog(
            context: mContext, title: resBody['message']);
        return false;
      }

      logger.i('비밀번호 변경 성공');
      DialogHelper.showAlertDialog(
        context: mContext,
        title: '비밀번호 변경 성공',
        onConfirm: () {
          state = FindUserState(email: "");
          Navigator.popAndPushNamed(mContext, '/login');
        },
      );
      return true;
    } catch (e, stackTrace) {
      ExceptionHandler.handleException('비밀번호 변경 통신 오류', stackTrace);
      return false;
    }
  }

  void clearState() {
    state = FindUserState(email: "");
  }
}

final findUserProvider = NotifierProvider<FindUserVm, FindUserState>(
  () => FindUserVm(),
);
