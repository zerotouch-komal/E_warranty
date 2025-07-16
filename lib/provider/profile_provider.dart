import 'package:e_warranty/models/profile_model.dart';
import 'package:e_warranty/services/profile/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await ProfileService.fetchProfile();
    } catch (e) {
      print('Error: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}