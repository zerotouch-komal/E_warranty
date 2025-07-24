class Address {
  final String street, city, state, country, zipCode;
  
  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
  });
  
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zipCode: json['zipCode'] ?? '',
    );
  }
}

class WalletBalance {
  final int totalAmount, usedAmount, remainingAmount;
  
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

class EWarrantyStats {
  final int totalWarranties, activeWarranties, expiredWarranties, claimedWarranties, totalPremiumCollected;
  final String? lastWarrantyDate;
  
  EWarrantyStats({
    required this.totalWarranties,
    required this.activeWarranties,
    required this.expiredWarranties,
    required this.claimedWarranties,
    required this.totalPremiumCollected,
    this.lastWarrantyDate,
  });
  
  factory EWarrantyStats.fromJson(Map<String, dynamic> json) {
    return EWarrantyStats(
      totalWarranties: json['totalWarranties'] ?? 0,
      activeWarranties: json['activeWarranties'] ?? 0,
      expiredWarranties: json['expiredWarranties'] ?? 0,
      claimedWarranties: json['claimedWarranties'] ?? 0,
      totalPremiumCollected: json['totalPremiumCollected'] ?? 0,
      lastWarrantyDate: json['lastWarrantyDate'],
    );
  }
}

class Permissions {
  final bool canCreateUser, canEditUser, canViewReports, canManageKeys;
  
  Permissions({
    required this.canCreateUser,
    required this.canEditUser,
    required this.canViewReports,
    required this.canManageKeys,
  });
  
  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      canCreateUser: json['canCreateUser'] ?? false,
      canEditUser: json['canEditUser'] ?? false,
      canViewReports: json['canViewReports'] ?? false,
      canManageKeys: json['canManageKeys'] ?? false,
    );
  }
}

class Company {
  final String name;
  final Address address;

  Company({
    required this.name,
    required this.address,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }
}

class User {
  final String name, email, phone;
  final WalletBalance walletBalance;
  final EWarrantyStats eWarrantyStats;
  final Permissions permissions;
  final Company company;
  final String userId, companyId, userType;
  final String? alternatePhone, parentUserId;
  final bool isActive;
  final int hierarchyLevel;
  final String createdBy;
  final String? lastLoginAt;
  final String createdAt, updatedAt;
  
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.walletBalance,
    required this.eWarrantyStats,
    required this.permissions,
    required this.company,
    required this.userId,
    required this.companyId,
    required this.userType,
    this.alternatePhone,
    this.parentUserId,
    required this.isActive,
    required this.hierarchyLevel,
    required this.createdBy,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      walletBalance: WalletBalance.fromJson(json['walletBalance'] ?? {}),
      eWarrantyStats: EWarrantyStats.fromJson(json['eWarrantyStats'] ?? {}),
      permissions: Permissions.fromJson(json['permissions'] ?? {}),
      company: Company.fromJson(json['company'] ?? {}),
      userId: json['userId'] ?? '',
      companyId: json['companyId'] ?? '',
      userType: json['userType'] ?? '',
      alternatePhone: json['alternatePhone'],
      parentUserId: json['parentUserId'],
      isActive: json['isActive'] ?? false,
      hierarchyLevel: json['hierarchyLevel'] ?? 0,
      createdBy: json['createdBy'] ?? '',
      lastLoginAt: json['lastLoginAt'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
  
}