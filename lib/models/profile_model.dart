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

class KeyAllocation {
  final int totalKeys, usedKeys, remainingKeys;
  KeyAllocation({
    required this.totalKeys,
    required this.usedKeys,
    required this.remainingKeys,
  });
  factory KeyAllocation.fromJson(Map<String, dynamic> json) {
    return KeyAllocation(
      totalKeys: json['totalKeys'],
      usedKeys: json['usedKeys'],
      remainingKeys: json['remainingKeys'],
    );
  }
}

class Company {
  final String name;
  final Address address;
  final KeyAllocation keyAllocation;

  Company({
    required this.name,
    required this.address,
    required this.keyAllocation,
  });

  factory Company.fromJson(Map json) {
    return Company(
      name: json['name'] ?? '',
      address: Address.fromJson(json['address']),
      keyAllocation: KeyAllocation.fromJson(json['keyAllocation']),
    );
  }
}


class User {
  final String name, email, phone;
  final KeyAllocation keyAllocation;
  final Company company;
  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.keyAllocation,
    required this.company,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      keyAllocation: KeyAllocation.fromJson(json['keyAllocation']),
      company: Company.fromJson(json['company']),
    );
  }
}
