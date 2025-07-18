import 'package:e_warranty/screens/login.dart';
import 'package:e_warranty/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:e_warranty/services/authentication/login_service.dart';
import 'package:e_warranty/utils/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _authToken;
  String? _refreshToken;
  String? _loginStatus;
  Map<String, dynamic>? _user;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get authToken => _authToken;
  String? get refreshToken => _refreshToken;
  String? get loginStatus => _loginStatus;
  Map<String, dynamic>? get user => _user;

  Future<void> initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn =
          await SharedPreferenceHelper.instance.getBool('KEYLOGIN') ?? false;
      _authToken = await SharedPreferenceHelper.instance.getString(
        'auth_token',
      );
      _refreshToken = await SharedPreferenceHelper.instance.getString(
        'refresh_token',
      );
      _loginStatus = await SharedPreferenceHelper.instance.getString(
        'loginStatus',
      );

      if (_isLoggedIn && (_authToken == null || _authToken!.isEmpty)) {
        _isLoggedIn = false;
        await SharedPreferenceHelper.instance.setBool('KEYLOGIN', false);
      }
    } catch (e) {
      print('Auth initialization error: $e');
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginResponse = await AuthService.login(email, password);

      if (loginResponse.success && loginResponse.data != null) {
        _authToken = loginResponse.data!.token;
        _refreshToken = loginResponse.data!.refreshToken;
        _user = loginResponse.data!.user;
        _isLoggedIn = true;
        _loginStatus = null;

        String userType = _user!['userType'].toString().toUpperCase();

        if (userType == 'RETAILER') {
          await SharedPreferenceHelper.instance.setString(
            'retailer_auth_token',
            _authToken!,
          );
          await SharedPreferenceHelper.instance.setString(
            'retailer_refresh_token',
            _refreshToken!,
          );
          await SharedPreferenceHelper.instance.setBool(
            'retailer_KEYLOGIN',
            true,
          );
          await SharedPreferenceHelper.instance.setString(
            'retailer_loginStatus',
            'LoggedIn',
          );
        } else {
          await SharedPreferenceHelper.instance.setString(
            'auth_token',
            _authToken!,
          );
          await SharedPreferenceHelper.instance.setString(
            'refresh_token',
            _refreshToken!,
          );
          await SharedPreferenceHelper.instance.setBool('KEYLOGIN', true);
          await SharedPreferenceHelper.instance.setString(
            'loginStatus',
            'LoggedIn',
          );
        }

        await SharedPreferenceHelper.instance.setString(
          'userId',
          _user!['userId'],
        );
        await SharedPreferenceHelper.instance.setString('name', _user!['name']);
        await SharedPreferenceHelper.instance.setString(
          'email',
          _user!['email'],
        );
        await SharedPreferenceHelper.instance.setString(
          'phone',
          _user!['phone'],
        );
        await SharedPreferenceHelper.instance.setString(
          'userType',
          _user!['userType'],
        );
        await SharedPreferenceHelper.instance.setString(
          'companyId',
          _user!['companyId'],
        );
        await SharedPreferenceHelper.instance.setString(
          'lastLoginAt',
          _user!['lastLoginAt'],
        );

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _loginStatus = loginResponse.message;
        await SharedPreferenceHelper.instance.setString(
          "loginStatus",
          _loginStatus!,
        );
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print("Login error in provider: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logoutWithoutNavigation() async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await LogoutService.logoutFromApi();

      if (success) {
        await SharedPreferenceHelper.instance.remove('auth_token');
        await SharedPreferenceHelper.instance.remove('refresh_token');
        await SharedPreferenceHelper.instance.setBool('KEYLOGIN', false);
        await SharedPreferenceHelper.instance.remove('loginStatus');
        await SharedPreferenceHelper.instance.remove('userId');
        await SharedPreferenceHelper.instance.remove('name');
        await SharedPreferenceHelper.instance.remove('email');
        await SharedPreferenceHelper.instance.remove('phone');
        await SharedPreferenceHelper.instance.remove('userType');
        await SharedPreferenceHelper.instance.remove('companyId');
        await SharedPreferenceHelper.instance.remove('lastLoginAt');

        await SharedPreferenceHelper.instance.remove('retailer_auth_token');
        await SharedPreferenceHelper.instance.remove('retailer_refresh_token');
        await SharedPreferenceHelper.instance.setBool(
          'retailer_KEYLOGIN',
          false,
        );
        await SharedPreferenceHelper.instance.remove('retailer_loginStatus');

        _isLoggedIn = false;
        _authToken = null;
        _refreshToken = null;
        _user = null;
        _loginStatus = null;

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Logout error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> logout(BuildContext context) async {
    final success = await logoutWithoutNavigation();

    if (success && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.logout, color: Colors.white),
                SizedBox(width: 8),
                Text('Logged out successfully'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      });
    }

    return success;
  }

  Future<void> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token =
          _authToken ??
          await SharedPreferenceHelper.instance.getString('auth_token') ??
          '';

      final response = await ChangePasswordService.changePassword(
        token: token,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      _isLoading = false;
      notifyListeners();

      if (response.success) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => ProfileScreen()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Change Password Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
