import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/wallet_allocation_mode.dart';
import 'package:e_warranty/models/wallet_history_model.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WalletHistoryService {
  Future<WalletHistoryResponse> fetchWalletHistory({
    int page = 1,
    String transactionType = 'ALL',
  }) async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');
    final userId = await SharedPreferenceHelper.instance.getString('userId');

    if (token == null || token.isEmpty) {
      throw Exception('No auth token found in SharedPreferences');
    }

    if (userId == null || userId.isEmpty) {
      throw Exception('No userId found in SharedPreferences');
    }

    final url = Uri.parse('${baseUrl}api/wallet/history');
    print('📡 Sending POST request to: $url');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'page': page,
        'transactionType': transactionType,
      }),
    );

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);
        return WalletHistoryResponse.fromJson(jsonBody);
      } catch (e) {
        print('❌ JSON Parsing Error: $e');
        throw Exception('Failed to parse wallet history data');
      }
    } else {
      throw Exception('Failed to load wallet history: ${response.statusCode}');
    }
  }
}

class WalletAllocationService {
  static Future<WalletAllocationResponse?> allocateWallet({
    required String toUserId,
    required int walletAmount,
  }) async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');
    if (token == null) return null;

    final url = Uri.parse('${baseUrl}api/wallet/allocate');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'toUserId': toUserId,
        'amount': walletAmount,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return WalletAllocationResponse.fromJson(data);
    } else {
      return null;
    }
  }
}
