class MyPosition {
  double? latitude; // 위도
  double? longitude; // 경도
  String? country; // 국가
  String? state; // 도/광역시
  String? city; // 시/구
  String? district; // 동/읍/면 (sublocality)
  String? neighborhood; // 마을/동네 (administrative_area_level_3)
  String? postalCode; // 우편번호


  
  MyPosition({
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.state,
    required this.city,
    required this.district,
    required this.neighborhood,
    required this.postalCode,
  });

  /// **값을 변경하여 새로운 객체 반환**
  MyPosition copyWith({
    double? latitude,
    double? longitude,
    String? country,
    String? state,
    String? city,
    String? district,
    String? neighborhood,
    String? postalCode,
  }) {
    return MyPosition(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      district: district ?? this.district,
      neighborhood: neighborhood ?? this.neighborhood,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  factory MyPosition.init() {
    return MyPosition(
        city: null,
        country: null,
        district: null,
        latitude: null,
        longitude: null,
        neighborhood: null,
        postalCode: null,
        state: null);
  }

  /// **Google API 응답(JSON) → `MyPosition` 객체로 변환**
  factory MyPosition.fromMap(Map<String, dynamic> json) {
    List<dynamic> addressComponents = json['address_components'] ?? [];

    // 특정 타입 값을 찾는 함수
    String? getAddressComponent(String type) {
      for (var component in addressComponents) {
        List<String> types = List<String>.from(component['types']);
        if (types.contains(type)) {
          return component['long_name'];
        }
      }
      return null;
    }

    return MyPosition(
      latitude: json['geometry']?['location']?['lat'],
      longitude: json['geometry']?['location']?['lng'],
      country: getAddressComponent("country"),
      state: getAddressComponent("administrative_area_level_1"),
      city: getAddressComponent("administrative_area_level_2") ??
          getAddressComponent("administrative_area_level_1"),
      district: getAddressComponent("sublocality_level_1") ??
          getAddressComponent("locality"),
      neighborhood: getAddressComponent("administrative_area_level_3"),
      postalCode: getAddressComponent("postal_code"),
    );
  }

  @override
  String toString() {
    return 'MyPosition{latitude: $latitude, longitude: $longitude, country: $country, state: $state, city: $city, district: $district, neighborhood: $neighborhood, postalCode: $postalCode}';
  }
}
