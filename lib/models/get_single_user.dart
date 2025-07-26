class UserDetails {
  final String id;
  final String userId;
  final String companyId;
  final String name;
  final String email;
  final String phone;
  final String? alternatePhone;
  final String userType;
  final bool isActive;
  final String? parentUserId;
  final int hierarchyLevel;
  final String? createdBy;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Address address;
  final Permissions? permissions;
  final WalletBalance walletBalance;
  final EWarrantyStats eWarrantyStats;

  UserDetails({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.name,
    required this.email,
    required this.phone,
    this.alternatePhone,
    required this.userType,
    required this.isActive,
    this.parentUserId,
    required this.hierarchyLevel,
    this.createdBy,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
    this.permissions,
    required this.walletBalance,
    required this.eWarrantyStats,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      companyId: json['companyId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      alternatePhone: json['alternatePhone'],
      userType: json['userType'] ?? '',
      isActive: json['isActive'] ?? false,
      parentUserId: json['parentUserId'],
      hierarchyLevel: json['hierarchyLevel'] ?? 0,
      createdBy: json['createdBy'],
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      address: Address.fromJson(json['address'] ?? {}),
      permissions: json['permissions'] != null ? Permissions.fromJson(json['permissions']) : null,
      walletBalance: WalletBalance.fromJson(json['walletBalance'] ?? {}),
      eWarrantyStats: EWarrantyStats.fromJson(json['eWarrantyStats'] ?? {}),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

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

class Permissions {
  final bool canCreateUser;
  final bool canEditUser;
  final bool canViewReports;
  final bool canManageKeys;

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

class WalletBalance {
  final double totalAmount;
  final double usedAmount;
  final double remainingAmount;

  WalletBalance({
    required this.totalAmount,
    required this.usedAmount,
    required this.remainingAmount,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      usedAmount: (json['usedAmount'] ?? 0).toDouble(),
      remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
    );
  }
}

class EWarrantyStats {
  final int totalWarranties;
  final int activeWarranties;
  final int expiredWarranties;
  final int claimedWarranties;
  final double totalPremiumCollected;
  final DateTime? lastWarrantyDate;

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
      totalPremiumCollected: (json['totalPremiumCollected'] ?? 0).toDouble(),
      lastWarrantyDate: json['lastWarrantyDate'] != null
          ? DateTime.tryParse(json['lastWarrantyDate'])
          : null,
    );
  }
}
