import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://afsarhealofy.github.io/flutterapitest';
  static const String apiEndpoint = '$baseUrl/flutterapitest.json';
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const int maxRetries = 3;

  static Future<ApiResponse?> fetchAppData() async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await http.get(
          Uri.parse(apiEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Healofy Flutter App/1.0',
          },
        ).timeout(timeoutDuration);

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final apiResponse = ApiResponse.fromJson(jsonData);
          return apiResponse;
        } else {
          if (attempt < maxRetries) {
            await Future.delayed(Duration(seconds: attempt * 2));
            continue;
          }
        }
      } catch (e) {
        if (attempt < maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        }
      }
    }

    return null;
  }

  static Future<bool> isApiReachable() async {
    try {
      final response = await http
          .head(Uri.parse(apiEndpoint))
          .timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static String getCurrentApiEndpoint() => apiEndpoint;
}
