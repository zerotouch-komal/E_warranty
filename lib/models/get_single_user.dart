import 'package:e_warranty/models/all_user_model.dart';

class UserDetails {
  final String name;
  final String email;
  final String phone;
  final String userType;
  final bool isActive;
  final Address address;
  final KeyAllocation keyAllocation;
  final Permissions permissions;

  UserDetails({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.isActive,
    required this.address,
    required this.keyAllocation,
    required this.permissions,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      userType: json['userType'],
      isActive: json['isActive'],
      address: Address.fromJson(json['address']),
      keyAllocation: KeyAllocation.fromJson(json['keyAllocation']),
      permissions: Permissions.fromJson(json['permissions']),
    );
  }
}

class Address {
  final String street, city, state, country, zipCode;
  Address({required this.street, required this.city, required this.state, required this.country, required this.zipCode});

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
  final bool canCreateUser, canEditUser, canViewReports, canManageKeys;
  Permissions({required this.canCreateUser, required this.canEditUser, required this.canViewReports, required this.canManageKeys});

  factory Permissions.fromJson(Map<String, dynamic> json) {
    return Permissions(
      canCreateUser: json['canCreateUser'],
      canEditUser: json['canEditUser'],
      canViewReports: json['canViewReports'],
      canManageKeys: json['canManageKeys'],
    );
  }
}