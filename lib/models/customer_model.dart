class CustomerResponse {
  final bool success;
  final CustomerData? data;
  final String? message;

  CustomerResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? CustomerData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class CustomerData {
  final List<Customer> customers;
  final int? totalPages;
  final int? currentPage;
  final int? totalCustomers;

  CustomerData({
    required this.customers,
    this.totalPages,
    this.currentPage,
    this.totalCustomers,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      customers: (json['customers'] as List<dynamic>?)
              ?.map((item) => Customer.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      totalCustomers: json['totalCustomers'],
    );
  }
}

class Customer {
  final String id;
  final String customerId;
  final String warrantyKey;
  final String companyId;
  final int status;
  final CustomerDetails customerDetails;
  final ProductDetails productDetails;
  final WarrantyDetails warrantyDetails;
  final CustomerDates dates;
  final bool isActive;
  final String? notes;

  Customer({
    required this.id,
    required this.customerId,
    required this.warrantyKey,
    required this.companyId,
    required this.status,
    required this.customerDetails,
    required this.productDetails,
    required this.warrantyDetails,
    required this.dates,
    required this.isActive,
    this.notes,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      warrantyKey: json['warrantyKey'] ?? '',
      companyId: json['companyId'] ?? '',
      status: json['status'] ?? 0,
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}),
      productDetails: ProductDetails.fromJson(json['productDetails'] ?? {}),
      warrantyDetails: WarrantyDetails.fromJson(json['warrantyDetails'] ?? {}),
      dates: CustomerDates.fromJson(json['dates'] ?? {}),
      isActive: json['isActive'] ?? false,
      notes: json['notes'],
    );
  }
}

class CustomerDetails {
  final String name;
  final CustomerAddress address;

  CustomerDetails({
    required this.name,
    required this.address,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
      address: CustomerAddress.fromJson(json['address'] ?? {}),
    );
  }
}

class CustomerAddress {
  final String city;
  final String state;

  CustomerAddress({
    required this.city,
    required this.state,
  });

  factory CustomerAddress.fromJson(Map<String, dynamic> json) {
    return CustomerAddress(
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class ProductDetails {
  final String modelName;
  final String category;

  ProductDetails({
    required this.modelName,
    required this.category,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      modelName: json['modelName'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class WarrantyDetails {
  final int warrantyPeriod;
  final double premiumAmount;

  WarrantyDetails({
    required this.warrantyPeriod,
    required this.premiumAmount,
  });

  factory WarrantyDetails.fromJson(Map<String, dynamic> json) {
    return WarrantyDetails(
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      premiumAmount: (json['premiumAmount'] ?? 0).toDouble(),
    );
  }
}

class CustomerDates {
  final DateTime? createdDate;

  CustomerDates({
    this.createdDate,
  });

  factory CustomerDates.fromJson(Map<String, dynamic> json) {
    return CustomerDates(
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
    );
  }
}