class Plan {
  final String id;
  final String planId;
  final String companyId;
  final String planName;
  final String planDescription;
  final int duration;
  final int premiumAmount;
  final List<String> eligibleCategories;
  final DateTime createdAt;

  Plan({
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

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['_id'] ?? '',
      planId: json['planId'] ?? '',
      companyId: json['companyId'] ?? '',
      planName: json['planName'] ?? '',
      planDescription: json['planDescription'] ?? '',
      duration: json['duration'] ?? 0,
      premiumAmount: json['premiumAmount'] ?? 0,
      eligibleCategories: List<String>.from(json['eligibleCategories'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'planId': planId,
      'companyId': companyId,
      'planName': planName,
      'planDescription': planDescription,
      'duration': duration,
      'premiumAmount': premiumAmount,
      'eligibleCategories': eligibleCategories,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PlanResponse {
  final bool success;
  final List<Plan> plans;
  final String? message;

  PlanResponse({
    required this.success,
    required this.plans,
    this.message,
  });

  factory PlanResponse.fromJson(Map<String, dynamic> json) {
    return PlanResponse(
      success: json['success'] ?? false,
      plans: json['data'] != null && json['data']['plans'] != null
          ? (json['data']['plans'] as List)
              .map((planJson) => Plan.fromJson(planJson))
              .toList()
          : [],
      message: json['message'],
    );
  }
}