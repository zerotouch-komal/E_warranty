class DashboardStats {
  final List<UserTypeCount> userTypeCount;
  final List<LastAddedUser> lastAddedUsers;
  final WalletBalance walletBalance;
  final int totalCustomersCount;

  DashboardStats({
    required this.userTypeCount, 
    required this.lastAddedUsers,
    required this.walletBalance,
    required this.totalCustomersCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      userTypeCount: List<UserTypeCount>.from(
          (json['userTypeCount'] ?? []).map((x) => UserTypeCount.fromJson(x))),
      lastAddedUsers: List<LastAddedUser>.from(
          (json['lastAddedUsers'] ?? []).map((x) => LastAddedUser.fromJson(x))),
      walletBalance: WalletBalance.fromJson(json['walletBalance'] ?? {}),
      totalCustomersCount: json['totalCustomersCount'] ?? 0,
    );
  }
}

class WalletBalance {
  final int totalAmount;
  final int usedAmount;
  final int remainingAmount;

  WalletBalance({
    required this.totalAmount,
    required this.usedAmount,
    required this.remainingAmount,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      totalAmount: json['totalAmount'] ?? 0,
      usedAmount: json['usedAmount'] ?? 0,
      remainingAmount: json['remainingAmount'] ?? 0,
    );
  }
}

class UserTypeCount {
  final String type;
  final int count;

  UserTypeCount({required this.type, required this.count});

  factory UserTypeCount.fromJson(Map<String, dynamic> json) {
    return UserTypeCount(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}

class LastAddedUser {
  final String id;
  final String customerId;
  final String warrantyKey;
  final int status;
  final CustomerDetails customerDetails;
  final ProductDetails productDetails;
  final WarrantyDetails warrantyDetails;
  final Dates dates;
  final bool isActive;
  final String notes;

  LastAddedUser({
    required this.id,
    required this.customerId,
    required this.warrantyKey,
    required this.status,
    required this.customerDetails,
    required this.productDetails,
    required this.warrantyDetails,
    required this.dates,
    required this.isActive,
    required this.notes,
  });

  factory LastAddedUser.fromJson(Map<String, dynamic> json) {
    return LastAddedUser(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      warrantyKey: json['warrantyKey'] ?? '',
      status: json['status'] ?? 0,
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}),
      productDetails: ProductDetails.fromJson(json['productDetails'] ?? {}),
      warrantyDetails: WarrantyDetails.fromJson(json['warrantyDetails'] ?? {}),
      dates: Dates.fromJson(json['dates'] ?? {}),
      isActive: json['isActive'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}

class CustomerDetails {
  final String name;

  CustomerDetails({required this.name});

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
    );
  }
}

class ProductDetails {
  final String modelName;
  final String category;

  ProductDetails({required this.modelName, required this.category});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      modelName: json['modelName'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class WarrantyDetails {
  final int warrantyPeriod;
  final int premiumAmount;

  WarrantyDetails({required this.warrantyPeriod, required this.premiumAmount});

  factory WarrantyDetails.fromJson(Map<String, dynamic> json) {
    return WarrantyDetails(
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      premiumAmount: json['premiumAmount'] ?? 0,
    );
  }
}

class Dates {
  final String createdDate;

  Dates({required this.createdDate});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      createdDate: json['createdDate'] ?? '',
    );
  }
}