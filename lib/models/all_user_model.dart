class UserModel {
  final String userId;
  final String name;
  final String userType;
  final String? parentUserId;
  final KeyAllocation keyAllocation;

  UserModel({
    required this.userId,
    required this.name,
    required this.userType,
    this.parentUserId,
    required this.keyAllocation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      userType: json['userType'],
      parentUserId: json['parentUserId'],
      keyAllocation: KeyAllocation.fromJson(json['keyAllocation']),
    );
  }
}

class KeyAllocation {
  final int totalKeys;
  final int usedKeys;
  final int remainingKeys;

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