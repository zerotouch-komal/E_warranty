class WarrantyPlans {
  final String id;
  final String planId;
  final String companyId;
  final String planName;
  final String planDescription;
  final int duration;
  final int premiumAmount;
  final List<String> eligibleCategories;
  final DateTime createdAt;

  WarrantyPlans({
    required this.id,
    required this.planId,
    required this.companyId,
    required this.planName,
    required this.planDescription,
    required this.duration,
    required this.premiumAmount,
    required this.eligibleCategories,
    required this.createdAt,
  });

  factory WarrantyPlans.fromJson(Map<String, dynamic> json) {
    return WarrantyPlans(
      id: json['_id'],
      planId: json['planId'],
      companyId: json['companyId'],
      planName: json['planName'],
      planDescription: json['planDescription'],
      duration: json['duration'],
      premiumAmount: json['premiumAmount'],
      eligibleCategories: List<String>.from(json['eligibleCategories']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
