import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/retailer/models/customer_model.dart';
import 'package:e_warranty/retailer/screens/retailer_view_customers.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

import 'package:http/http.dart' as http;

Future<void> submitCustomerData(Map<String, dynamic> combinedData) async {
  final url = Uri.parse('${baseUrl}/api/customers/create');
  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJVU0VSXzE3NTI1NTk4OTIwMDVfN2p4anI4czV6IiwiY29tcGFueUlkIjoiQ09NUEFOWV8xNzUyNTU4NDk2NTM1Xzk3bXJ1eGQ2OSIsInVzZXJUeXBlIjoiUkVUQUlMRVIiLCJpYXQiOjE3NTI3NTI5MjgsImV4cCI6MTc1MjgzOTMyOH0.otI98_H5g1LPhoO-XvHw0thnPa__Q0LUhsstaJbR8Lc";

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(combinedData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(' Data submitted successfully.');
      print('Response: ${response.body}');
    } else {
      print(' Failed to submit. Status: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print(' Error: $e');
  }
}


Future<List<CustomerData>> fetchAllCustomers() async {
  final url = Uri.parse('${baseUrl}api/customers/all');
  final token = await SharedPreferenceHelper.instance.getString(
      'retailer_auth_token',
    );

  try {
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final customers = data['data']['customers'] as List;
      print('Customers fetched successfully.');
      return customers.map((e) => CustomerData.fromJson(e)).toList();
    } else {
      print('Failed to fetch customers. Status: ${response.statusCode}');
      throw Exception("Failed to fetch customers");
    }
  } catch (e) {
    print('Error fetching customers data: $e');
    throw Exception("Error: $e");
  }
}
