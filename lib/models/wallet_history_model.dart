class WalletHistoryResponse {
  final bool success;
  final HistoryData data;

  WalletHistoryResponse({required this.success, required this.data});

  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WalletHistoryResponse(
      success: json['success'] ?? false,
      data: HistoryData.fromJson(json['data'] ?? {}),
    );
  }
}

class HistoryData {
  final List<HistoryItem> history;
  final Pagination pagination;

  HistoryData({required this.history, required this.pagination});

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      history: (json['history'] as List? ?? [])
          .map((item) => HistoryItem.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class HistoryItem {
  final String id;
  final String transactionId;
  final String companyId;
  final String transactionType;
  final String fromUserId;
  final String toUserId;
  final int amount;
  final String? warrantyKey;
  final CustomerDetails customerDetails;
  final bool isActive;
  final String? notes;
  final bool isRestrictedOperation;
  final String transactionDate;
  final String createdAt;
  final UserInfo fromUser;
  final UserInfo toUser;

  HistoryItem({
    required this.id,
    required this.transactionId,
    required this.companyId,
    required this.transactionType,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    this.warrantyKey,
    required this.customerDetails,
    required this.isActive,
    this.notes,
    required this.isRestrictedOperation,
    required this.transactionDate,
    required this.createdAt,
    required this.fromUser,
    required this.toUser,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['_id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      companyId: json['companyId'] ?? '',
      transactionType: json['transactionType'] ?? '',
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'] ?? '',
      amount: json['amount'] ?? 0,
      warrantyKey: json['warrantyKey'],
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}),
      isActive: json['isActive'] ?? false,
      notes: json['notes'],
      isRestrictedOperation: json['isRestrictedOperation'] ?? false,
      transactionDate: json['transactionDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      fromUser: UserInfo.fromJson(json['fromUser'] ?? {}),
      toUser: UserInfo.fromJson(json['toUser'] ?? {}),
    );
  }

  String get walletTransactionId => transactionId;
  String get walletTransactionType => transactionType;
  int get walletAmount => amount;
}

class CustomerDetails {
  final String? customerId;
  final String? customerName;
  final String? productModel;
  final double? premiumAmount;

  CustomerDetails({
    this.customerId,
    this.customerName,
    this.productModel,
    this.premiumAmount,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      customerId: json['customerId'],
      customerName: json['customerName'],
      productModel: json['productModel'],
      premiumAmount: json['premiumAmount']?.toDouble(),
    );
  }
}

class UserInfo {
  final String id;
  final String userId;
  final String userType;
  final String name;

  UserInfo({
    required this.id,
    required this.userId,
    required this.userType,
    required this.name,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalData;
  final int limit;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalData,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalData: json['totalData'] ?? 0,
      limit: json['limit'] ?? 10,
    );
  }
}
