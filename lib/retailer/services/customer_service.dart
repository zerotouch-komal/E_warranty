import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> submitCustomerData(Map<String, dynamic> combinedData) async {
  final url = Uri.parse('https://boxer-patient-slowly.ngrok-free.app/api/customers/create');
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
