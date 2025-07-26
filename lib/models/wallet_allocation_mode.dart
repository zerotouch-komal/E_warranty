class WalletAllocationResponse {
  final bool success;
  final String message;
  final WalletRecord walletRecord;

  WalletAllocationResponse({
    required this.success,
    required this.message,
    required this.walletRecord,
  });

  factory WalletAllocationResponse.fromJson(Map<String, dynamic> json) {
    return WalletAllocationResponse(
      success: json['success'],
      message: json['message'],
      walletRecord: WalletRecord.fromJson(json['data']['keyRecord']),
    );
  }
}


class WalletRecord {
  final String transactionId;
  final String companyId;
  final String transactionType;
  final String fromUserId;
  final String toUserId;
  final int amount;
  final bool isActive;
  final bool isRestrictedOperation;
  final String transactionDate;

  WalletRecord({
    required this.transactionId,
    required this.companyId,
    required this.transactionType,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.isActive,
    required this.isRestrictedOperation,
    required this.transactionDate,
  });

  factory WalletRecord.fromJson(Map<String, dynamic> json) {
    return WalletRecord(
      transactionId: json['transactionId'],
      companyId: json['companyId'],
      transactionType: json['transactionType'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      amount: json['amount'],
      isActive: json['isActive'],
      isRestrictedOperation: json['isRestrictedOperation'],
      transactionDate: json['transactionDate'],
    );
  }
}
