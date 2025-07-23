import 'dart:convert';
import 'package:e_warranty/retailer/models/history_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

Future<Map<String, String>> _getAuthHeaders() async {
  final token = SharedPreferenceHelper.instance.getString(
    'retailer_auth_token',
  );
  return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
}

Future<List<RetailerHistoryData>> fetchRetailerHistoryData() async {
  final userId = SharedPreferenceHelper.instance.getString('userId');
  final url = Uri.parse('${baseUrl}api/wallet/history');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"userId": userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> historyList = jsonData['data']['history'];

      return historyList
          .map((item) => RetailerHistoryData.fromJson(item))
          .toList();
    } else {
      print('Failed to fetch History data: ${response.body}');
      throw Exception('Failed to fetch History data');
    }
  } catch (e) {
    print('Error fetching History Data: $e');
    rethrow;
  }
}
