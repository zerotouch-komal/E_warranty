import 'dart:convert';
import 'package:e_warranty/retailer/models/dashboard_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

Future<Map<String, String>> _getAuthHeaders() async {
  final token = SharedPreferenceHelper.instance.getString(
    'retailer_auth_token',
  );
  return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
}

Future<DashboardData> fetchRetailerDashboardStats() async {
  final url = Uri.parse('${baseUrl}api/dashboard/retailer-stats');
  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return DashboardData.fromJson(jsonData);
    } else {
      print('Failed to fetch Dashboard stats: ${response.body}');
      throw Exception('Failed to fetch dashboard stats');
    }
  } catch (e) {
    print('Error fetching dashboard data: $e');
    rethrow;
  }
}
