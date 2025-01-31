import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8080';
// final String apiUrl = 'http://192.168.0.127:8080';
