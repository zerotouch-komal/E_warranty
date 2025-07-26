import 'package:e_warranty/models/wallet_allocation_mode.dart';
import 'package:e_warranty/services/wallet/wallet_service.dart';
import 'package:flutter/material.dart';
import '../models/wallet_history_model.dart';

class KeyHistoryProvider with ChangeNotifier {
  final WalletHistoryService _service = WalletHistoryService();

  List<HistoryItem> _historyList = [];
  bool _isLoading = false;
  bool _hasLoadedOnce = false;
  String _currentFilter = 'ALL';

  List<HistoryItem> get historyList => _historyList;
  bool get isLoading => _isLoading;
  bool get hasLoadedOnce => _hasLoadedOnce;
  String get currentFilter => _currentFilter;

  Future<void> getKeyHistory({bool showLoader = true}) async {
    await getKeyHistoryWithFilter('ALL', showLoader: showLoader);
  }

  Future<void> getKeyHistoryWithFilter(String filter, {bool showLoader = true}) async {
    print('🔁 Filter changed to: $filter');
    print('📡 API call triggered for filter: $filter');

    if (showLoader) {
      _isLoading = true;
      notifyListeners();
    }

    _currentFilter = filter;
    
    try {
      final response = await _service.fetchWalletHistory(transactionType: filter);
      _historyList = response.data.history;
      _hasLoadedOnce = true;
      print('✅ Data fetched successfully for filter: $filter');
    } catch (e) {
      _historyList = [];
      print('❌ Error fetching key history for filter [$filter]: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshInBackground() async {
    print('🔄 Background refresh started for filter: $_currentFilter');
    try {
      final response = await _service.fetchWalletHistory(transactionType: _currentFilter);
      _historyList = response.data.history;
      notifyListeners();
      print('✅ Background refresh completed.');
    } catch (e) {
      print('❌ Error in background refresh: $e');
    }
  }
}

class KeyTransferProvider with ChangeNotifier {
  WalletRecord? _keyRecord;
  bool _isLoading = false;
  String? _error;

  WalletRecord? get keyRecord => _keyRecord;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> transferKeys(String toUserId, int keyCount) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await WalletAllocationService.allocateWallet(
        toUserId: toUserId,
        walletAmount: keyCount,
      );

      if (response != null && response.success) {
        _keyRecord = response.walletRecord;
        notifyListeners();
        return true;
      } else {
        _error = response?.message ?? 'Unknown error occurred';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}