import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://afsarhealofy.github.io/flutterapitest';
  static const String apiEndpoint = '$baseUrl/flutterapitest.json';
  static const Duration timeoutDuration = Duration(seconds: 30);
  static const int maxRetries = 3;

  /// Fetches app data from the remote API endpoint
  /// Returns ApiResponse on success, null on failure
  static Future<ApiResponse?> fetchAppData() async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('🌐 Fetching data from API (attempt $attempt/$maxRetries)...');
        print('📡 API Endpoint: $apiEndpoint');

        final response = await http.get(
          Uri.parse(apiEndpoint),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'User-Agent': 'Healofy Flutter App/1.0',
          },
        ).timeout(timeoutDuration);

        print('📊 API Response Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final apiResponse = ApiResponse.fromJson(jsonData);

          print('✅ API data loaded successfully');
          print('📱 Content items: ${apiResponse.data.contents.length}');

          return apiResponse;
        } else {
          print('❌ API Error: HTTP ${response.statusCode}');
          if (attempt < maxRetries) {
            print('⏳ Retrying in ${attempt * 2} seconds...');
            await Future.delayed(Duration(seconds: attempt * 2));
            continue;
          }
        }
      } catch (e) {
        print('❌ Network Error (attempt $attempt): $e');
        if (attempt < maxRetries) {
          print('⏳ Retrying in ${attempt * 2} seconds...');
          await Future.delayed(Duration(seconds: attempt * 2));
          continue;
        } else {
          print('💔 All retry attempts failed');
        }
      }
    }

    return null;
  }

  /// Validates if the API endpoint is reachable
  static Future<bool> isApiReachable() async {
    try {
      final response = await http
          .head(Uri.parse(apiEndpoint))
          .timeout(Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (e) {
      print('🔍 API reachability check failed: $e');
      return false;
    }
  }

  /// Gets the current API endpoint being used
  static String getCurrentApiEndpoint() => apiEndpoint;
}
