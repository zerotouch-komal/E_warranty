class RetailerHierarchy {
  final DirectParent? directParent;
  final String id;
  final String userId;
  final String companyId;
  final String createdAt;
  final String updatedAt;
  final List<dynamic>? crossCompanyAccess;
  final List<HierarchyPath> hierarchyPath;

  RetailerHierarchy({
    this.directParent,
    required this.id,
    required this.userId,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    this.crossCompanyAccess,
    required this.hierarchyPath,
  });

  factory RetailerHierarchy.fromJson(Map<String, dynamic> json) {
    return RetailerHierarchy(
      directParent:
          json['directParent'] != null
              ? DirectParent.fromJson(json['directParent'])
              : null,
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      companyId: json['companyId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      crossCompanyAccess: json['crossCompanyAccess'] ?? [],
      hierarchyPath:
          (json['hierarchyPath'] ?? [])
              .map<HierarchyPath>((e) => HierarchyPath.fromJson(e))
              .toList(),
    );
  }

    @override
  String toString() {
    return 'RetailerHierarchy(userId: $userId, directParent: $directParent, hierarchyPath: $hierarchyPath)';
  }
}

class DirectParent {
  final String userId;
  final String userType;
  final String name;

  DirectParent({
    required this.userId,
    required this.userType,
    required this.name,
  });

  factory DirectParent.fromJson(Map<String, dynamic> json) {
    return DirectParent(
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class HierarchyPath {
  final String userId;
  final String userType;
  final String name;
  final int level;
  final String id;

  HierarchyPath({
    required this.userId,
    required this.userType,
    required this.name,
    required this.level,
    required this.id,
  });

  factory HierarchyPath.fromJson(Map<String, dynamic> json) {
    return HierarchyPath(
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      name: json['name'] ?? '',
      level: json['level'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
