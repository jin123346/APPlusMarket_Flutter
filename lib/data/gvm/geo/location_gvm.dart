import 'dart:async';
import 'dart:convert';

import 'package:applus_market/data/model/auth/my_position.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../_core/utils/apiUrl.dart';
import '../../../_core/utils/dio.dart';
import '../../../_core/utils/logger.dart';

class LocationGvm extends Notifier<MyPosition?> {
  late InAppWebViewController webViewController;
  List<dynamic> _addressComponents = [];

  @override
  MyPosition? build() {
    _init();
    return null;
  }

  void _init() async {
    Position? position = await getCurrentLocation();
    if (position == null) {
      state = MyPosition.init();
      return;
    }

    MyPosition? myPosition =
        await getAddressFromCoordinates(position.latitude, position.longitude);

    state = myPosition;
    logger.i('현재 나의 위치 상태 : ${state!}');
  }

  static Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // 현재 위치 가져오기
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await requestPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<MyPosition?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    latitude = 35.162553736212246;
    longitude = 129.06232965169252;
    try {
      final String url = "https://maps.googleapis.com/maps/api/geocode/json";
      final response = await dio.get(
        url,
        queryParameters: {
          "latlng": '$latitude,$longitude',
          "key": googleKey,
          "language": "ko"
        },
      );

      logger.i('결과 : $response');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        logger.i('전체 지도 정보 : $data');

        if (data['results'].isNotEmpty) {
          List<dynamic> results = data['results'];
          logger.i('지도 1 : $results');

          if (results.isNotEmpty) {
            Map<String, dynamic> firstResult = results[0]; // 첫 번째 결과 가져오기
            logger.i("첫 번째 결과값: $firstResult");

            return MyPosition.fromMap(firstResult);
          }

          return null;
        }

        return null;
      }
    } catch (e, stackTrace) {
      logger.w(e);
    }

    return null;
  }
}

final locationProvider = NotifierProvider<LocationGvm, MyPosition?>(
  () => LocationGvm(),
);
