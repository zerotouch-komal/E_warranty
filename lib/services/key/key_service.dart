import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/key_history_model.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KeyHistoryService {
  Future<KeyHistoryResponse> fetchKeyHistory() async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No auth token found in SharedPreferences');
    }

    final url = Uri.parse('${baseUrl}api/keys/history');
    print('📡 Sending GET request to: $url');
    print('🔐 Using token: $token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);
        return KeyHistoryResponse.fromJson(jsonBody);
      } catch (e) {
        print('❌ JSON Parsing Error: $e');
        throw Exception('Failed to parse key history data');
      }
    } else {
      throw Exception('Failed to load key history: ${response.statusCode}');
    }
  }
}
