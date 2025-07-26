import 'package:e_warranty/models/add_user_model.dart';
import 'package:e_warranty/models/all_user_model.dart';
import 'package:e_warranty/services/all_user/all_user_service.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

  class UserProvider with ChangeNotifier {
    final UserService _userService = UserService();
    List<UserModel> _users = [];
    String? _loggedInUserId;
    bool _isLoading = false;
    bool _isFetchingMore = false;
    String? _error;
    int _page = 1;
    bool _hasMore = true;
    String _currentUserType = 'ALL';
    int _totalData = 0;

    List<UserModel> get users => _users;
    bool get isLoading => _isLoading;
    bool get isFetchingMore => _isFetchingMore;
    String? get error => _error;
    String get currentUserType => _currentUserType;
    int get totalData => _totalData;

    Future<void> fetchAllUsers({bool refresh = false, String userType = 'ALL'}) async {
      if (_isLoading) return;
      _isLoading = true;
      _error = null;
      _page = 1;
      _hasMore = true;
      _currentUserType = userType;
      notifyListeners();

      try {
        _loggedInUserId = await SharedPreferenceHelper.instance.getString('userId');
        _users = await _userService.fetchAllUsers(page: _page, userType: userType);
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    Future<void> fetchMoreUsers() async {
      if (_isFetchingMore || !_hasMore) return;
      _isFetchingMore = true;
      notifyListeners();

      try {
        _page++;
        final newUsers = await _userService.fetchAllUsers(
          page: _page, 
          userType: _currentUserType,
        );
        if (newUsers.isEmpty) {
          _hasMore = false;
        } else {
          _users.addAll(newUsers);
        }
      } catch (e) {
        _error = e.toString();
      } finally {
        _isFetchingMore = false;
        notifyListeners();
      }
    }

    String getCreatorLabel(UserModel user) {
      if (user.parentUserId == null) return 'Unknown';
      if (user.parentUserId == _loggedInUserId) return 'You';

      final parent = _users.firstWhere(
        (u) => u.userId == user.parentUserId,
        orElse: () => UserModel(
          id: '',
          userId: '',
          companyId: '',
          userType: '',
          name: 'Unknown',
          email: '',
          phone: '',
          isActive: false,
          parentUserId: null,
          address: Address(city: '', state: ''),
          walletBalance: WalletBalance(remainingAmount: 0),
          createdAt: DateTime.now(),
        ),
      );

      return parent.name;
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
