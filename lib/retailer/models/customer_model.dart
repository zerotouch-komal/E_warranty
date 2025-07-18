class CustomerData {
  final String name;
  final String modelName;
  final String planId;
  final int premiumAmount;
  final String warrantyKey;
  final String customerId;
  final DateTime createdDate;

  CustomerData({
    required this.name,
    required this.modelName,
    required this.planId,
    required this.premiumAmount,
    required this.warrantyKey,
    required this.customerId,
    required this.createdDate,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      name: json['customerDetails']['name'] ?? '',
      modelName: json['productDetails']['modelName'] ?? '',
      planId: json['warrantyDetails']['planId'] ?? '',
      premiumAmount: json['warrantyDetails']['premiumAmount'] ?? 0,
      warrantyKey: json['warrantyKey'] ?? '',
      customerId: json['customerId']?.toString() ?? '',
      createdDate: DateTime.parse(json['dates']['createdDate']),
    );
  }
}
