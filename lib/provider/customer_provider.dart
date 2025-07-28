import 'package:e_warranty/models/customer_detail.dart';
import 'package:e_warranty/services/all_customer/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import '../models/customer_model.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _error;
  int? _totalPages;
  int? _totalCustomers;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  String? get error => _error;
  int? get totalPages => _totalPages;
  int? get totalCustomers => _totalCustomers;

  void reset() {
    _customers.clear();
    _currentPage = 1;
    _hasMore = true;
    _error = null;
    _totalPages = null;
    _totalCustomers = null;
    notifyListeners();
  }

  Future<void> loadCustomers({bool refresh = false}) async {
    if (refresh) {
      reset();
    }

    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        _error = 'Authentication token not found. Please login again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await CustomerService.getAllCustomers(
        token: token,
        page: _currentPage,
        limit: 10,
      );

      if (response.success && response.data != null) {
        _customers = response.data!.customers;
        _totalPages = response.data!.totalPages;
        _totalCustomers = response.data!.totalCustomers;
        
        if (_totalPages != null) {
          _hasMore = _currentPage < _totalPages!;
        } else {
          _hasMore = response.data!.customers.length >= 10;
        }
        
        _error = null;
      } else {
        _error = response.message ?? 'Failed to load customers';
        _customers = [];
      }
    } catch (e) {
      _error = 'Error loading customers: ${e.toString()}';
      _customers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCustomers() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        _error = 'Authentication token not found. Please login again.';
        _isLoadingMore = false;
        notifyListeners();
        return;
      }

      final nextPage = _currentPage + 1;
      final response = await CustomerService.getAllCustomers(
        token: token,
        page: nextPage,
        limit: 10,
      );

      if (response.success && response.data != null) {
        final newCustomers = response.data!.customers;
        
        if (newCustomers.isNotEmpty) {
          _customers.addAll(newCustomers);
          _currentPage = nextPage;
          
          if (response.data!.totalPages != null) {
            _totalPages = response.data!.totalPages;
            _hasMore = _currentPage < _totalPages!;
          } else {
            _hasMore = newCustomers.length >= 10;
          }
        } else {
          _hasMore = false;
        }
        
        _error = null;
      } else {
        _error = response.message ?? 'Failed to load more customers';
      }
    } catch (e) {
      _error = 'Error loading more customers: ${e.toString()}';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<String?> _getAuthToken() async {
    try {
      String? token = await SharedPreferenceHelper.instance.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        token = await SharedPreferenceHelper.instance.getString('retailer_auth_token');
      }
      
      return token;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
  
  Future<void> searchCustomers(String query) async {
    if (query.isEmpty) {
      loadCustomers(refresh: true);
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        _error = 'Authentication token not found. Please login again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final filteredCustomers = _customers.where((customer) {
        return customer.customerDetails.name.toLowerCase().contains(query.toLowerCase()) ||
               customer.productDetails.modelName.toLowerCase().contains(query.toLowerCase()) ||
               customer.productDetails.category.toLowerCase().contains(query.toLowerCase()) ||
               customer.customerId.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _customers = filteredCustomers;
      _error = null;
    } catch (e) {
      _error = 'Error searching customers: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCustomers() async {
    await loadCustomers(refresh: true);
  }
}

// CUSTOMER DETAIL PROVIDER

class CustomerDetailProvider extends ChangeNotifier {
  CustomerDetail? _customerDetail;
  bool _isLoading = false;
  String? _error;

  CustomerDetail? get customerDetail => _customerDetail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCustomerDetail({
    required String customerId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        _error = 'Authentication token not found. Please login again.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await CustomerDetailService.getCustomerDetail(
        token: token,
        customerId: customerId,
      );

      if (response.success && response.data != null) {
        _customerDetail = response.data!.customer;
        _error = null;
      } else {
        _customerDetail = null;
        _error = response.message ?? 'Failed to fetch customer details';
      }
    } catch (e) {
      _customerDetail = null;
      _error = 'An unexpected error occurred';
      print('Customer detail provider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCustomerDetail() {
    _customerDetail = null;
    _error = null;
    notifyListeners();
  }

  Future<void> refreshCustomerDetail({
    required String customerId,
  }) async {
    await fetchCustomerDetail(customerId: customerId);
  }

  Future<String?> _getAuthToken() async {
    try {
      String? token = await SharedPreferenceHelper.instance.getString('auth_token');
      if (token == null || token.isEmpty) {
        token = await SharedPreferenceHelper.instance.getString('retailer_auth_token');
      }
      return token;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
}