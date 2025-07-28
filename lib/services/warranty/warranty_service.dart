import 'dart:convert';
import 'package:e_warranty/constants/config.dart';
import 'package:e_warranty/models/warranty_model.dart';
import 'package:http/http.dart' as http;

class PlanService {
  
  static Future<PlanResponse> getPlans(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}api/warranty-plans/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return PlanResponse.fromJson(jsonData);
      } else {
        return PlanResponse(
          success: false,
          plans: [],
          message: 'Failed to fetch plans: ${response.statusCode}',
        );
      }
    } catch (e) {
      return PlanResponse(
        success: false,
        plans: [],
        message: 'Network error: $e',
      );
    }
  }
}