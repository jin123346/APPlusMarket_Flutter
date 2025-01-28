import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../_core/apiUrl.dart';

String? globalBaseUrl;

class DynamicBaseUrlInterceptor extends Interceptor {
  String checkPlatform() {
    if (kIsWeb) {
      print("Running on the web!");
      return 'web';
    } else if (Platform.isAndroid) {
      print("Running on Android!");
      return 'Android';
    } else if (Platform.isIOS) {
      print("Running on iOS!");
      return 'iOS';
    } else {
      print("Running on an unknown platform!");
      return 'unknown';
    }
  }

  Future<String> getLocalIp() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          // IPv4 타입이면서 루프백 주소가 아닌 경우
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            print('Detected IP: ${addr.address}');
            return addr.address;
          }
        }
      }
      throw Exception('No valid local IP address found');
    } catch (e) {
      print('Error detecting local IP: $e');
      return '127.0.0.1'; // 기본값
    }
  }

  Future<String> getBaseUrl() async {
    String platform = checkPlatform();
    String wifiIp = apiUrl;
    if (platform == 'Android') {
      if (isEmulator()) {
        return 'http://10.0.2.2:8080'; // Android 에뮬레이터
      } else {
        // Wi-Fi IP 가져오기

        if (wifiIp != '127.0.0.1') {
          // 유효한 Wi-Fi IP가 반환되면 사용
          return 'http://$wifiIp:8080';
        } else {
          // Wi-Fi가 아니라면 getLocalIp() 호출
          String localIp = await getLocalIp();
          return 'http://$localIp:8080';
        }
      }
    } else if (platform == 'iOS') {
      return 'http://127.0.0.1:8080'; // iOS 에뮬레이터
    } else if (platform == 'web') {
      return 'http://127.0.0.1:8080'; // web 에뮬레이터
    } else {
      String localIp = await getLocalIp(); // 기타 플랫폼
      return 'http://$localIp:8080';
    }
  }

  bool isEmulator() {
    return Platform.environment.containsKey('ANDROID_EMULATOR_BUILD');
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String baseUrl = await getBaseUrl();
    options.baseUrl = baseUrl;
    print('Final Request URL: ${options.baseUrl}${options.path}');
    super.onRequest(options, handler);
  }
}
