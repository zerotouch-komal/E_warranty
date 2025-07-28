import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/customer_detail.dart';
import 'package:e_warranty/models/customer_model.dart';
import 'package:http/http.dart' as http;

class CustomerService {

  static Future<CustomerResponse> getAllCustomers({
    required String token,
    required int page,
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}api/customers/all');
      
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        'page': page,
        'limit': limit,
      });

      print('Fetching customers - Page: $page, Limit: $limit');
      
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Customer API Response Status: ${response.statusCode}');
      print('Customer API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CustomerResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        return CustomerResponse(
          success: false,
          message: 'Unauthorized access. Please login again.',
        );
      } else {
        return CustomerResponse(
          success: false,
          message: 'Failed to fetch customers. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Customer Service Error: $e');
      return CustomerResponse(
        success: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}

class CustomerDetailService {

  static Future<CustomerDetailResponse> getCustomerDetail({
    required String token,
    required String customerId,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}api/customers/get');
      
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = json.encode({
        'customerId': customerId,
      });

      print('Fetching customer details for ID: $customerId');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print('Customer detail response status: ${response.statusCode}');
      print('Customer detail response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CustomerDetailResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        return CustomerDetailResponse(
          success: false,
          message: 'Unauthorized. Please login again.',
        );
      } else if (response.statusCode == 404) {
        return CustomerDetailResponse(
          success: false,
          message: 'Customer not found.',
        );
      } else {
        final jsonData = json.decode(response.body);
        return CustomerDetailResponse(
          success: false,
          message: jsonData['message'] ?? 'Failed to fetch customer details',
        );
      }
    } catch (e) {
      print('Customer detail service error: $e');
      return CustomerDetailResponse(
        success: false,
        message: 'Network error. Please check your connection.',
      );
    }
  }
}