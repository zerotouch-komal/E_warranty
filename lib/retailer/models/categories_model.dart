class Categories {
  final String id;
  final String categoryName;
  final bool isActive;

  Categories({
    required this.id,
    required this.categoryName,
    required this.isActive,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['_id'] ?? '',
      categoryName: json['categoryName'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
