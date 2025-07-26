import 'dart:convert';
import 'dart:io';
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

Future<String?> uploadFile(File file) async {
  final url = Uri.parse('${baseUrl}api/customers/handle-file');

  final headers = await _getAuthHeaders(); 

  final request = http.MultipartRequest('POST', url);
  request.fields['mode'] = 'upload';
  request.files.add(await http.MultipartFile.fromPath('file', file.path));
  request.headers.addAll(headers); 

  final response = await request.send();

  if (response.statusCode == 200) {
    final resStr = await response.stream.bytesToString();
    final decoded = jsonDecode(resStr);
    final String path = decoded['message'];
    return 'https://boxer-patient-slowly.ngrok-free.app$path';
  } else {
    return null;
  }
}


Future<bool> deleteFile(String imageUrl) async {
  final url = Uri.parse('${baseUrl}api/customers/handle-file');

  final response = await http.post(url, body: {
    'mode': 'delete',
    'deleteFile': imageUrl,
  });

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);
    return decoded['message'] == 'deleted';
  }

  return false;
}

