import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
  2025.1.26 하진희 baseUrl 모음집

 */
final env = dotenv.env['API_BASE_URL'];
final String apiUrl = 'http://$env:8080' ?? 'http://127.0.0.1:8080';
// final String apiUrl = 'http://192.168.0.127:8080';

//지니 집
// final String apiUrl = 'http://192.168.219.109:8080';
