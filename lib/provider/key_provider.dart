import 'package:e_warranty/models/key_allocation_mode.dart';
import 'package:e_warranty/services/key/key_service.dart';
import 'package:flutter/material.dart';
import '../models/key_history_model.dart';

class KeyHistoryProvider with ChangeNotifier {
  final KeyHistoryService _service = KeyHistoryService();
  List<HistoryItem> _historyList = [];
  bool _isLoading = false;
  bool _hasLoadedOnce = false;

  List<HistoryItem> get historyList => _historyList;
  bool get isLoading => _isLoading;

  Future<void> getKeyHistory({bool showLoader = true}) async {
    if (showLoader) _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.fetchKeyHistory();
      _historyList = response.data.history;
      _hasLoadedOnce = true;
    } catch (e) {
      _historyList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshInBackground() async {
    try {
      final response = await _service.fetchKeyHistory();
      _historyList = response.data.history;
      notifyListeners();
    } catch (e) {
      
    }
  }

  bool get hasLoadedOnce => _hasLoadedOnce;
}


class KeyTransferProvider with ChangeNotifier {
  KeyRecord? _keyRecord;
  bool _isLoading = false;
  String? _error;

  KeyRecord? get keyRecord => _keyRecord;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> transferKeys(String toUserId, int keyCount) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await KeyAllocationService.allocateKeys(
        toUserId: toUserId,
        keyCount: keyCount,
      );

      if (response != null && response.success) {
        _keyRecord = response.keyRecord;
        notifyListeners();
        return true;
      } else {
        _error = response?.message ?? 'Unknown error';
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