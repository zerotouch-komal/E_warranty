import 'package:e_warranty/models/dashboard_model.dart';
import 'package:e_warranty/services/dashboard/dashboard_service.dart';
import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _service = DashboardService();
  DashboardStats? _stats;
  bool _isLoading = false;

  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardStats() async {
    _isLoading = true;
    notifyListeners();
    _stats = await _service.fetchDashboardStats();
    _isLoading = false;
    notifyListeners();
  }
}