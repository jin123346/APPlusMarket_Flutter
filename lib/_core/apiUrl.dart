import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8080';
