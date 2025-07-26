import 'package:flutter/material.dart';
import '../models/get_single_user.dart';
import '../services/all_user/all_user_service.dart';

class SingleUserProvider with ChangeNotifier {
  UserDetails? _userDetails;
  bool _isDetailsLoading = false;
  String? _error;

  UserDetails? get userDetails => _userDetails;
  bool get isDetailsLoading => _isDetailsLoading;
  String? get error => _error;

  Future<void> fetchUserDetails(String userId) async {
    _isDetailsLoading = true;
    _error = null;
    notifyListeners();

    try {
      final details = await UserDetailsService.fetchUserDetails(userId);
      _userDetails = details;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isDetailsLoading = false;
      notifyListeners();
    }
  }

  void clearUserDetails() {
    _userDetails = null;
    notifyListeners();
  }
}
