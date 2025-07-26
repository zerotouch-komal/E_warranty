import 'dart:convert';
import 'package:e_warranty/retailer/models/warranty_plans_model.dart';
import 'package:http/http.dart' as http;
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/retailer/models/customer_details_model.dart';
import 'package:e_warranty/retailer/models/customers_list_model.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

Future<Map<String, String>> _getAuthHeaders() async {
  final token = await SharedPreferenceHelper.instance.getString(
    'retailer_auth_token',
  );
  return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
}
Future<http.Response> submitCustomerData(Map<String, dynamic> combinedData) async {
  final url = Uri.parse('${baseUrl}api/customers/create');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(combinedData),
    );

    print('Response (${response.statusCode}): ${response.body}');
    return response;
  } catch (e) {
    print('Error submitting customer data: $e');
    rethrow;
  }
}


Future<List<WarrantyPlans>> fetchWarrantyPlans() async {
  final url = Uri.parse('${baseUrl}api/warranty-plans/all');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List plans = jsonData['data']['plans'];
      print("plans : $plans");
      return plans.map((e) => WarrantyPlans.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to fetch warrranty plans. Status: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('Error fetching warrranty : $e');
    rethrow;
  }
}


Future<List<CustomersData>> fetchAllCustomers() async {
  final url = Uri.parse('${baseUrl}api/customers/all');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List customers = jsonData['data']['customers'];
      return customers.map((e) => CustomersData.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to fetch customers. Status: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('Error fetching all customers: $e');
    rethrow;
  }
}

Future<ParticularCustomerData> fetchCustomerDetails(String customerId) async {
  final url = Uri.parse('${baseUrl}api/customers/get');

  try {
    final headers = await _getAuthHeaders();
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({'customerId': customerId}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final customer = ParticularCustomerData.fromJson(
        jsonData['data']['customer'],
      );
      return customer;
    } else {
      throw Exception(
        'Failed to fetch customer. Status: ${response.statusCode}',
      );
    }
  } catch (e) {
    print('Error fetching particular customer: $e');
    rethrow;
  }
}
