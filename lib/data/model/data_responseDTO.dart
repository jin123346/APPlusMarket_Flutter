import 'responseDTO.dart';

class DataResponseDTO<T> extends ResponseDTO {
  final T? data;

  DataResponseDTO({
    required String status,
    required int code,
    required String message,
    this.data,
  }) : super(status: status, code: code, message: message);

  int getCode() {
    return code;
  }

  factory DataResponseDTO.fromJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromDataJson) {
    return DataResponseDTO<T>(
      status: json['status'],
      code: json['code'],
      message: json['message'],
      data: json['data'] != null ? fromDataJson(json['data']) : null,
    );
  }
}
