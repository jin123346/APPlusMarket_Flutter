import 'package:flutter/material.dart';

import '../data/repository/auth/auth_repository.dart';

void main() async {
  AuthRepository authRepository = AuthRepository();
  await authRepository.apiInsertUser({
    "uid": "qwe123",
    "password": 123,
    'hp': 01055958375,
    'name': '지니',
    'email': 'hajhi789',
    'nickName': "지니123",
    'birthday': "1111-11-11T00:00:00.000"
  });
}
