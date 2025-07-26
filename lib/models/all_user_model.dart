class UserModel {
  final String id;
  final String userId;
  final String companyId;
  final String userType;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  final String? parentUserId;
  final Address address;
  final WalletBalance walletBalance;
  final DateTime createdAt;
  final ParentUser? parentUser; // ✅ New field

  UserModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.userType,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    this.parentUserId,
    required this.address,
    required this.walletBalance,
    required this.createdAt,
    this.parentUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      companyId: json['companyId'] ?? '',
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isActive: json['isActive'] ?? false,
      parentUserId: json['parentUserId'],
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(city: '', state: ''),
      walletBalance: json['walletBalance'] != null
          ? WalletBalance.fromJson(json['walletBalance'])
          : WalletBalance(remainingAmount: 0),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      parentUser: json['parentUser'] != null
          ? ParentUser.fromJson(json['parentUser'])
          : null,
    );
  }
}

class ParentUser {
  final String userId;
  final String name;

  ParentUser({
    required this.userId,
    required this.name,
  });

  factory ParentUser.fromJson(Map<String, dynamic> json) {
    return ParentUser(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Address {
  final String city;
  final String state;

  Address({
    required this.city,
    required this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class WalletBalance {
  final double remainingAmount;

  WalletBalance({
    required this.remainingAmount,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
    );
  }
}
