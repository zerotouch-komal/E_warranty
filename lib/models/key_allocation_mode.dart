class KeyAllocationResponse {
  final bool success;
  final String message;
  final KeyRecord keyRecord;

  KeyAllocationResponse({
    required this.success,
    required this.message,
    required this.keyRecord,
  });

  factory KeyAllocationResponse.fromJson(Map<String, dynamic> json) {
    return KeyAllocationResponse(
      success: json['success'],
      message: json['message'],
      keyRecord: KeyRecord.fromJson(json['data']['keyRecord']),
    );
  }
}

class KeyRecord {
  final String keyId;
  final String fromUserId;
  final String toUserId;
  final int keyCount;

  KeyRecord({
    required this.keyId,
    required this.fromUserId,
    required this.toUserId,
    required this.keyCount,
  });

  factory KeyRecord.fromJson(Map<String, dynamic> json) {
    return KeyRecord(
      keyId: json['keyId'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      keyCount: json['keyCount'],
    );
  }
}
