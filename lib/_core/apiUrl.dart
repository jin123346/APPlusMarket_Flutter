import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

final String apiUrl = dotenv.env['API_BASE_URL'] ?? 'http://127.0.0.1:8080';
