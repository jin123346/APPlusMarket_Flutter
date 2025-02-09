/*
  2025.02.09 하진희 addressBook 모델 
 */
class MyAddress {
  int? id;
  int? userId;
  bool? isDefault;
  String? postcode;
  String? address1;
  String? address2;
  String? message;
  String? title;
  String? receiverName;
  String? receiverPhone;

  MyAddress(
      {this.id,
      required this.userId,
      required this.isDefault,
      required this.postcode,
      required this.address1,
      required this.address2,
      required this.message,
      required this.title,
      required this.receiverName,
      required this.receiverPhone});

  MyAddress copyWith({
    int? id,
    int? userId,
    bool? isDefault,
    String? postcode,
    String? address1,
    String? address2,
    String? message,
    String? title,
    String? receiverName,
    String? receiverPhone,
  }) {
    return MyAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      isDefault: isDefault ?? this.isDefault,
      message: message ?? this.message,
      postcode: postcode ?? this.postcode,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      title: title ?? this.title,
    );
  }

  factory MyAddress.fromJson(Map<String, dynamic> json) {
    return MyAddress(
      id: json['id'],
      userId: json['userId'],
      isDefault: json['isDefault'] == true ? true : false,
      postcode: json['postcode'],
      address1: json['address1'],
      address2: json['address2'],
      message: json['message'],
      title: json['title'],
      receiverName: json['receiverName'],
      receiverPhone: json['receiverPhone'],
    );
  }

  @override
  String toString() {
    return 'MyAddress{id: $id, userId: $userId, isDefault: $isDefault, postcode: $postcode, address1: $address1, address2: $address2, message: $message, title: $title, receiverName: $receiverName, receiverPhone: $receiverPhone}';
  }
}
