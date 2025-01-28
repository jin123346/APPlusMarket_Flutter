import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpController extends Notifier<List<TextEditingController>> {
  final TextEditingController uidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController verificationCodeController =
      TextEditingController();
  final TextEditingController hpController = TextEditingController();
  final TextEditingController hpAgencyController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  List<TextEditingController> controllers = [];
  @override
  build() {
    controllers.add(uidController);
    controllers.add(passwordController);
    controllers.add(confirmPasswordController);
    controllers.add(emailController);
    controllers.add(verificationCodeController);
    controllers.add(hpController);
    controllers.add(hpAgencyController);
    controllers.add(nicknameController);
    controllers.add(nameController);
    controllers.add(birthDateController);
    return controllers;
  }

  void clearControllers() {
    uidController.clear();
    passwordController.clear();
    emailController.clear();
    verificationCodeController.clear();
    hpController.clear();
    hpAgencyController.clear();
    nicknameController.clear();
    nameController.clear();
    birthDateController.clear();
  }

  void dispose() {
    uidController.dispose();
    passwordController.dispose();
    emailController.dispose();
    verificationCodeController.dispose();
    hpController.dispose();
    hpAgencyController.dispose();
    nicknameController.dispose();
    nameController.dispose();
    birthDateController.dispose();
  }
}

final SignUpControllerProvider =
    NotifierProvider<SignUpController, List<TextEditingController>>(
  () {
    return SignUpController();
  },
);
