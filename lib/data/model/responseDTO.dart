import 'package:flutter/material.dart';

class ResponseDTO {
  final String status;
  final int code;
  final String message;

  ResponseDTO({
    required this.status,
    required this.code,
    required this.message,
  });

  // JSON 파싱 메서드
  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      status: json['status'],
      code: json['code'],
      message: json['message'],
    );
  }
}
