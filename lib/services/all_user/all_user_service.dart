import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/add_user_model.dart';
import 'package:e_warranty/models/all_user_model.dart';
import 'package:e_warranty/models/get_single_user.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<List<UserModel>> fetchAllUsers({
    int page = 1,
    String userType = 'ALL',
  }) async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception('No auth token found in SharedPreferences');
    }

    final url = Uri.parse('${baseUrl}api/users/get-all');
    print('📡 Sending POST request to: $url');
    print('🔐 Using token: $token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'userType': userType,
        'page': page,
      }),
    );

    print('📥 Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);
        final usersJson = jsonBody['data']['users'] as List;
        return usersJson.map((user) => UserModel.fromJson(user)).toList();
      } catch (e) {
        print('❌ JSON Parsing Error: $e');
        throw Exception('Failed to parse user data');
      }
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
}


// GET SINGLE USER
class UserDetailsService {
  static Future<UserDetails?> fetchUserDetails(String userId) async {
    final token = await SharedPreferenceHelper.instance.getString('auth_token');

    if (token == null || token.isEmpty) return null;

    final url = Uri.parse('${baseUrl}api/users/get');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return UserDetails.fromJson(jsonBody['data']['user']);
    } else {
      return null;
    }
  }
}

// ADD USER

class RegisterService {
  static Future<RegisterResponse?> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String userType,
    required String alternatePhone,
    required String street,
    required String city,
    required String state,
    required String country,
    required String zipCode,
  }) async {
    try {
      final token = await SharedPreferenceHelper.instance.getString('auth_token');
      final url = Uri.parse('${baseUrl}api/auth/register');

      print('🔁 RegisterService: Sending POST request to $url');
      print('🔐 Token: ${token ?? "No token"}');
      print('📦 Request Body: ${jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'userType': userType,
        'alternatePhone': alternatePhone,
        'address': {
          'street': street,
          'city': city,
          'state': state,
          'country': country,
          'zipCode': zipCode,
        }
      })}');

      final response = await http.post(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'userType': userType,
          'alternatePhone': alternatePhone,
          'address': {
            'street': street,
            'city': city,
            'state': state,
            'country': country,
            'zipCode': zipCode,
          }
        }),
      );

      print('📥 Response Status Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final registerResponse = RegisterResponse.fromJson(data);
        print('✅ Registration Successful: ${registerResponse.message}');
        return registerResponse;
      } else {
        print('❌ Registration failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('❗ Exception during registration: $e');
      print(stackTrace);
      return null;
    }
  }
}