import 'package:applus_market/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  String? _accessToken;

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final mContext = navigator.currentContext;

  // Save refreshToken
  Future<void> saveAccessToken(String accessToken) async {
    await storage.write(key: 'accessToken', value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'accessToken');
  }

  //로그아웃시
  // Delete tokens
  Future<void> clearToken() async {
    await storage.delete(key: 'accessToken');
    Navigator.pushNamed(mContext!, '/login');
  }
}
