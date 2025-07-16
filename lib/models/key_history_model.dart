class KeyHistoryResponse {
  final bool success;
  final HistoryData data;

  KeyHistoryResponse({required this.success, required this.data});

  factory KeyHistoryResponse.fromJson(Map<String, dynamic> json) {
    return KeyHistoryResponse(
      success: json['success'],
      data: HistoryData.fromJson(json['data']),
    );
  }
}

class HistoryData {
  final List<HistoryItem> history;

  HistoryData({required this.history});

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      history: (json['history'] as List)
          .map((item) => HistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class HistoryItem {
  final String keyId;
  final String keyType;
  final int keyCount;
  final String transactionDate;

  HistoryItem({
    required this.keyId,
    required this.keyType,
    required this.keyCount,
    required this.transactionDate,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      keyId: json['keyId'],
      keyType: json['keyType'],
      keyCount: json['keyCount'],
      transactionDate: json['transactionDate'],
    );
  }
}
