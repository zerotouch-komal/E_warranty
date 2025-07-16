class DashboardStats {
  final List<UserTypeCount> userTypeCount;
  final List<LastAddedUser> lastAddedUsers;
  final KeyAllocation keyAllocation;
  final int totalCustomersCount;

  DashboardStats({
    required this.userTypeCount, 
    required this.lastAddedUsers,
    required this.keyAllocation,
    required this.totalCustomersCount,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      userTypeCount: List<UserTypeCount>.from(
          json['userTypeCount'].map((x) => UserTypeCount.fromJson(x))),
      lastAddedUsers: List<LastAddedUser>.from(
          json['lastAddedUsers'].map((x) => LastAddedUser.fromJson(x))),
      keyAllocation: KeyAllocation.fromJson(json['keyAllocation']),
      totalCustomersCount: json['totalCustomersCount'] ?? 0,
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
      totalKeys: json['totalKeys'] ?? 0,
      usedKeys: json['usedKeys'] ?? 0,
      remainingKeys: json['remainingKeys'] ?? 0,
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
  final String name;
  final String email;
  final String phone;
  final String userType;
  final int totalKeys;
  final int usedKeys;
  final int remainingKeys;

  LastAddedUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    required this.totalKeys,
    required this.usedKeys,
    required this.remainingKeys,
  });

  factory LastAddedUser.fromJson(Map<String, dynamic> json) {
    final keyAllocation = json['keyAllocation'] ?? {};
    return LastAddedUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? '',
      totalKeys: keyAllocation['totalKeys'] ?? 0,
      usedKeys: keyAllocation['usedKeys'] ?? 0,
      remainingKeys: keyAllocation['remainingKeys'] ?? 0,
    );
  }
}