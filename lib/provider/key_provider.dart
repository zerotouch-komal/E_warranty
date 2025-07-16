import 'package:e_warranty/services/key/key_service.dart';
import 'package:flutter/material.dart';
import '../models/key_history_model.dart';

class KeyHistoryProvider with ChangeNotifier {
  final KeyHistoryService _service = KeyHistoryService();
  List<HistoryItem> _historyList = [];
  bool _isLoading = false;

  List<HistoryItem> get historyList => _historyList;
  bool get isLoading => _isLoading;

  Future<void> getKeyHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _service.fetchKeyHistory();
      _historyList = response.data.history;
    } catch (e) {
      _historyList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
