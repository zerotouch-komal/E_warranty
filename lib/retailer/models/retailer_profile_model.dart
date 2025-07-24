class RetailerProfile {
  final Address address;
  final WalletBalance walletBalance;
  final String userType;
  final String name;
  final String email;
  final String phone;
  final String alternatePhone;

  RetailerProfile({
    required this.address,
    required this.walletBalance,
    required this.userType,
    required this.name,
    required this.email,
    required this.phone,
    required this.alternatePhone,
  });

  factory RetailerProfile.fromJson(Map<String, dynamic> json) {
    return RetailerProfile(
      address: Address.fromJson(json['address']),
      walletBalance: WalletBalance.fromJson(json['walletBalance']),
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      alternatePhone: json['alternatePhone'] ?? '',
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
