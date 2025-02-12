import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
  2025.1.26 하진희 baseUrl 모음집
  TODO : 자신의 로컬 IP로 바꿔서 작업
 */
final env = dotenv.env['API_BASE_URL'];
final String apiUrl = 'http://$env:8080' ?? 'http://192.168.0.127:8080';

// final String apiUrl = 'http://192.168.0.127:8080';

// 지니 집
// final String apiUrl = 'http://192.168.219.109:8080';

// 미니 집
// final String apiUrl = 'http://192.168.123.101:8080';

// 미니꼬
//final String apiUrl = 'http://$env:8080' ?? 'http://192.168.0.32:8080';

final defaultProfile = 'assets/images/default-profile.png';

final kakaoApiKey = 'bee0049d1dc30f192fc49b3c0a0b9d97';
final googleKey = 'AIzaSyCoUUCbbb60fkaSxQ1pw65UFKJgQ-TzFLI';
