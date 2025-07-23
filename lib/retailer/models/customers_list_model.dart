class CustomersData {
  final String name;
  final String modelName;
  final String planId;
  final int premiumAmount;
  final String warrantyKey;
  final String customerId;
  final DateTime createdDate;
  final String category;
  final bool isActive;
  final int warrantyPeriod;
  final String? notes;

  CustomersData({
    required this.name,
    required this.modelName,
    required this.planId,
    required this.premiumAmount,
    required this.warrantyKey,
    required this.customerId,
    required this.createdDate,
    required this.category,
    required this.isActive,
    required this.warrantyPeriod,
    this.notes,
  });

  factory CustomersData.fromJson(Map<String, dynamic> json) {
    return CustomersData(
      name: json['customerDetails']['name'] ?? '',
      modelName: json['productDetails']['modelName'] ?? '',
      planId: json['warrantyDetails']['planId'] ?? '',
      premiumAmount: json['warrantyDetails']['premiumAmount'] ?? 0,
      warrantyKey: json['warrantyKey'] ?? '',
      customerId: json['customerId']?.toString() ?? '',
      createdDate: DateTime.parse(json['dates']['createdDate']),
      category: json['productDetails']['category'] ?? '',
      isActive: json['isActive'] ?? false,
      warrantyPeriod: json['warrantyDetails']['warrantyPeriod'] ?? 0,
      notes: json['notes'], 
    );
  }
}
