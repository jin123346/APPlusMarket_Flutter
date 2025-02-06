import 'package:applus_market/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  String? _accessToken;
  String? _refreshToken;

  final FlutterSecureStorage storage = FlutterSecureStorage();
  final mContext = navigatorkey.currentContext;

  // Save refreshToken
  void saveAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  String? getAccessToken() {
    return _accessToken;
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refreshToken');
  }

  //로그아웃시
  // Delete tokens
  Future<void> clearToken() async {
    _accessToken = null;
    await storage.delete(key: 'refreshToken');
  }
}
