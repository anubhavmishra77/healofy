import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class ApiService {
  static const String baseUrl = 'https://afsarhealofy.github.io/flutterapitest';

  static Future<ApiResponse?> fetchAppData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/flutterapitest.json'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse.fromJson(jsonData);
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
