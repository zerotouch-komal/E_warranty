import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/profile_model.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<User> fetchProfile() async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No auth token found in SharedPreferences');
    }

    final url = Uri.parse('${baseUrl}api/auth/me');
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
      final jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData['data']['user']);
    } else {
      throw Exception('Failed to load profile');
    }
  }
}