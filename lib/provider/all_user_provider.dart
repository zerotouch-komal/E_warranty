import 'package:e_warranty/models/add_user_model.dart';
import 'package:e_warranty/models/all_user_model.dart';
import 'package:e_warranty/models/get_single_user.dart';
import 'package:e_warranty/services/all_user/all_user_service.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  List<UserModel> _users = [];
  String? _loggedInUserId;
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAllUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _loggedInUserId = await SharedPreferenceHelper.instance.getString('userId');
      _users = await _userService.fetchAllUsers();
    } catch (e) {
      print('❌ Error fetching users: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getCreatorLabel(UserModel user) {
    if (user.parentUserId == null) return 'Unknown';
    if (user.parentUserId == _loggedInUserId) return 'You';

    final parent = _users.firstWhere(
      (u) => u.userId == user.parentUserId,
      orElse: () => UserModel(
        userId: '',
        name: 'Unknown',
        userType: '',
        keyAllocation: KeyAllocation(totalKeys: 0, usedKeys: 0, remainingKeys: 0),
      ),
    );
    return parent.name;
  }

  // USER DETAIL 
  UserDetails? _userDetails;
  bool _isDetailsLoading = false;
  String? _detailsError;

  UserDetails? get userDetails => _userDetails;
  bool get isDetailsLoading => _isDetailsLoading;
  String? get detailsError => _detailsError;

  Future<void> fetchUserDetails(String userId) async {
    _isDetailsLoading = true;
    _detailsError = null;
    notifyListeners();

    try {
      final result = await UserDetailsService.fetchUserDetails(userId);
      if (result != null) {
        _userDetails = UserDetails(
          name: result.name,
          email: result.email,
          phone: result.phone,
          userType: result.userType,
          isActive: result.isActive,
          address: result.address,
          keyAllocation: KeyAllocation(
            totalKeys: result.keyAllocation.totalKeys,
            usedKeys: result.keyAllocation.usedKeys,
            remainingKeys: result.keyAllocation.remainingKeys,
          ),
          permissions: result.permissions,
        );
      }
    } catch (e) {
      print('❌ Error fetching user details: $e');
      _detailsError = e.toString();
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

// ADD USER

class RegisterProvider with ChangeNotifier {
  RegisterResponse? _registerResponse;
  bool _isLoading = false;

  RegisterResponse? get registerResponse => _registerResponse;
  bool get isLoading => _isLoading;

  Future<void> registerUser({
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
    _isLoading = true;
    notifyListeners();

    _registerResponse = await RegisterService.registerUser(
      name: name,
      email: email,
      phone: phone,
      password: password,
      userType: userType,
      alternatePhone: alternatePhone,
      street: street,
      city: city,
      state: state,
      country: country,
      zipCode: zipCode,
    );

    _isLoading = false;
    notifyListeners();
  }
}
