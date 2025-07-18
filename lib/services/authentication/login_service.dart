import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/change_password_model.dart';
import 'package:e_warranty/models/login_model.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<LoginResponse> login(String email, String password) async {
    try {
      final url = Uri.parse('${baseUrl}api/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login Response Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: responseData['message'] ?? 'Login failed',
          data: null,
        );
      }
    } catch (e) {
      print("Login Exception: $e");
      return LoginResponse(
        success: false,
        message: 'Network error. Please try again.',
        data: null,
      );
    }
  }
}

// LOGOUT SERVICE
class LogoutService {
  static Future<bool> logoutFromApi() async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');
    final retailerToken = await SharedPreferenceHelper.instance.getString(
      'retailer_auth_token',
    );

    if ((token == null || token.isEmpty) &&
        (retailerToken == null || retailerToken.isEmpty)) {
      print('❌ No auth token found');
      return false;
    }

    final usedToken = token != null && token.isNotEmpty ? token : retailerToken;

    final url = Uri.parse('${baseUrl}api/auth/logout');
    print('📡 Sending POST request to: $url');
    print('🔐 Using token: $usedToken');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $usedToken',
      },
      body: jsonEncode({
        'token': usedToken, // 👈 sending in body too
      }),
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    return response.statusCode == 200;
  }
}

// CHANGE PASSWORD

class ChangePasswordService {
  static Future<ChangePasswordResponse> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}api/auth/change-password');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        }),
      );

      print('Change Password Response Code: ${response.statusCode}');
      print('Change Password Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return ChangePasswordResponse.fromJson(responseData);
      } else {
        final responseData = jsonDecode(response.body);
        return ChangePasswordResponse(
          success: false,
          message: responseData['message'] ?? 'Password change failed',
        );
      }
    } catch (e) {
      print("Change Password Exception: $e");
      return ChangePasswordResponse(
        success: false,
        message: 'Network error. Please try again.',
      );
    }
  }
}
