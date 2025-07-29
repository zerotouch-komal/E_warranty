import 'dart:convert';
import 'package:e_warranty/retailer/models/retailer_hierarchy_model.dart';
import 'package:e_warranty/retailer/models/retailer_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

Future<Map<String, String>> _getAuthHeaders() async {
  final token = SharedPreferenceHelper.instance.getString(
    'retailer_auth_token',
  );
  return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
}

Future<RetailerProfile> fetchRetailerProfile() async {
  final url = Uri.parse('${baseUrl}api/auth/me');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final userJson = responseData['data']['user'];
      final user = RetailerProfile.fromJson(userJson);
      return user;
    } else {
      print('Failed to fetch Profile data: ${response.body}');
      throw Exception('Failed to fetch Profile data');
    }
  } catch (e) {
    print('Error fetching Profile Data: $e');
    rethrow;
  }
}

Future<RetailerHierarchy> fetchRetailerHierarchy() async {
  final url = Uri.parse('${baseUrl}api/users/hierarchy');
  final userId = SharedPreferenceHelper.instance.getString('userId');
  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final userJson = responseData['data']['hierarchy'];
      print('RetailerHierarchy $userJson');
      final hierarchy = RetailerHierarchy.fromJson(userJson);
      return hierarchy;
    } else {
      print('Failed to fetch hierarchy data: ${response.body}');
      throw Exception('Failed to fetch hierarchy data');
    }
  } catch (e) {
    print('Error fetching hierarchy Data: $e');
    rethrow;
  }
}

Future<void> changeRetailerPassword(
  currentPassword,
  newPassword,
  confirmPassword,
) async {
  final url = Uri.parse('${baseUrl}api/auth/change-password');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print("pswd: $responseData");
    } else {
      print('Failed to change password: ${response.body}');
      throw Exception('Failed to change password');
    }
  } catch (e) {
    print('Error changing password: $e');
    rethrow;
  }
}
