import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../model/auth/user.dart';

final Dio _dio = Dio()
  ..interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));
Future<void> apiInsertUser(User user) async {
  const String url = "http://localhost:8080/auth/register"; // API URL
  try {
    final response = await _dio.post(
      url,
      data: {
        "uid": user.uid,
        "password": user.password,
        "hp": user.hp,
        "name": user.name,
        "email": user.email,
        "nickName": user.nickName,
        "birthday": user.birthday?.toIso8601String(), // DateTime -> String 변환
      },
      options: Options(
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("User successfully inserted: ${response.data}");
    } else {
      print("Failed to insert user: ${response.statusCode}");
    }
  } catch (e) {
    print("Error occurred while inserting user: $e");
  }
}
