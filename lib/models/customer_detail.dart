class CustomerDetailResponse {
  final bool success;
  final CustomerDetailData? data;
  final String? message;

  CustomerDetailResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory CustomerDetailResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDetailResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? CustomerDetailData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class CustomerDetailData {
  final CustomerDetail customer;

  CustomerDetailData({required this.customer});

  factory CustomerDetailData.fromJson(Map<String, dynamic> json) {
    return CustomerDetailData(
      customer: CustomerDetail.fromJson(json['customer']),
    );
  }
}

class CustomerDetail {
  final String id;
  final String customerId;
  final String warrantyKey;
  final String companyId;
  final String retailerId;
  final int status;
  final bool isActive;
  final String notes;
  final CustomerDetails customerDetails;
  final ProductDetails productDetails;
  final InvoiceDetails invoiceDetails;
  final ProductImages productImages;
  final WarrantyDetails warrantyDetails;
  final PaymentDetails paymentDetails;
  final Hierarchy hierarchy;
  final Dates dates;

  CustomerDetail({
    required this.id,
    required this.customerId,
    required this.warrantyKey,
    required this.companyId,
    required this.retailerId,
    required this.status,
    required this.isActive,
    required this.notes,
    required this.customerDetails,
    required this.productDetails,
    required this.invoiceDetails,
    required this.productImages,
    required this.warrantyDetails,
    required this.paymentDetails,
    required this.hierarchy,
    required this.dates,
  });

  factory CustomerDetail.fromJson(Map<String, dynamic> json) {
    return CustomerDetail(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      warrantyKey: json['warrantyKey'] ?? '',
      companyId: json['companyId'] ?? '',
      retailerId: json['retailerId'] ?? '',
      status: json['status'] ?? 0,
      isActive: json['isActive'] ?? false,
      notes: json['notes'] ?? '',
      customerDetails: CustomerDetails.fromJson(json['customerDetails'] ?? {}),
      productDetails: ProductDetails.fromJson(json['productDetails'] ?? {}),
      invoiceDetails: InvoiceDetails.fromJson(json['invoiceDetails'] ?? {}),
      productImages: ProductImages.fromJson(json['productImages'] ?? {}),
      warrantyDetails: WarrantyDetails.fromJson(json['warrantyDetails'] ?? {}),
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails'] ?? {}),
      hierarchy: Hierarchy.fromJson(json['hierarchy'] ?? {}),
      dates: Dates.fromJson(json['dates'] ?? {}),
    );
  }
}

class CustomerDetails {
  final String name;
  final String email;
  final String mobile;
  final String alternateNumber;
  final Address address;

  CustomerDetails({
    required this.name,
    required this.email,
    required this.mobile,
    required this.alternateNumber,
    required this.address,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      alternateNumber: json['alternateNumber'] ?? '',
      address: Address.fromJson(json['address'] ?? {}),
    );
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipCode;

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

  String get fullAddress {
    return [street, city, state, country, zipCode]
        .where((element) => element.isNotEmpty)
        .join(', ');
  }
}

class ProductDetails {
  final int originalWarranty;
  final String categoryId;
  final String modelName;
  final String imei1;
  final String imei2;
  final String brand;
  final String category;
  final double purchasePrice;

  ProductDetails({
    required this.originalWarranty,
    required this.categoryId,
    required this.modelName,
    required this.imei1,
    required this.imei2,
    required this.brand,
    required this.category,
    required this.purchasePrice,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      originalWarranty: json['orignalWarranty'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      modelName: json['modelName'] ?? '',
      imei1: json['imei1'] ?? '',
      imei2: json['imei2'] ?? '',
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      purchasePrice: (json['purchasePrice'] ?? 0).toDouble(),
    );
  }
}

class InvoiceDetails {
  final String invoiceNumber;
  final double invoiceAmount;
  final String invoiceImage;
  final DateTime? invoiceDate;

  InvoiceDetails({
    required this.invoiceNumber,
    required this.invoiceAmount,
    required this.invoiceImage,
    this.invoiceDate,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceAmount: (json['invoiceAmount'] ?? 0).toDouble(),
      invoiceImage: json['invoiceImage'] ?? '',
      invoiceDate: json['invoiceDate'] != null 
          ? DateTime.tryParse(json['invoiceDate']) 
          : null,
    );
  }
}

class ProductImages {
  final String frontImage;
  final String backImage;
  final List<String> additionalImages;

  ProductImages({
    required this.frontImage,
    required this.backImage,
    required this.additionalImages,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
      frontImage: json['frontImage'] ?? '',
      backImage: json['backImage'] ?? '',
      additionalImages: (json['additionalImages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  List<String> get allImages {
    List<String> images = [];
    if (frontImage.isNotEmpty) images.add(frontImage);
    if (backImage.isNotEmpty) images.add(backImage);
    images.addAll(additionalImages);
    return images;
  }
}

class WarrantyDetails {
  final String planId;
  final String planName;
  final int warrantyPeriod;
  final DateTime? startDate;
  final DateTime? expiryDate;
  final double premiumAmount;

  WarrantyDetails({
    required this.planId,
    required this.planName,
    required this.warrantyPeriod,
    this.startDate,
    this.expiryDate,
    required this.premiumAmount,
  });

  factory WarrantyDetails.fromJson(Map<String, dynamic> json) {
    return WarrantyDetails(
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      startDate: json['startDate'] != null 
          ? DateTime.tryParse(json['startDate']) 
          : null,
      expiryDate: json['expiryDate'] != null 
          ? DateTime.tryParse(json['expiryDate']) 
          : null,
      premiumAmount: (json['premiumAmount'] ?? 0).toDouble(),
    );
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  int get daysRemaining {
    if (expiryDate == null) return 0;
    final difference = expiryDate!.difference(DateTime.now());
    return difference.inDays > 0 ? difference.inDays : 0;
  }
}

class PaymentDetails {
  final String paymentStatus;
  final DateTime? paymentDate;
  final String paymentMethod;
  final String orderId;
  final String paymentOrderId;
  final String paymentId;
  final String transactionId;

  PaymentDetails({
    required this.paymentStatus,
    this.paymentDate,
    required this.paymentMethod,
    required this.orderId,
    required this.paymentOrderId,
    required this.paymentId,
    required this.transactionId,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      paymentStatus: json['paymentStatus'] ?? '',
      paymentDate: json['paymentDate'] != null 
          ? DateTime.tryParse(json['paymentDate']) 
          : null,
      paymentMethod: json['paymentMethod'] ?? '',
      orderId: json['orderId'] ?? '',
      paymentOrderId: json['paymentOrderId'] ?? '',
      paymentId: json['paymentId'] ?? '',
      transactionId: json['transactionId'] ?? '',
    );
  }
}

class Hierarchy {
  final Retailer retailer;
  final List<DistributorChain> distributorChain;

  Hierarchy({
    required this.retailer,
    required this.distributorChain,
  });

  factory Hierarchy.fromJson(Map<String, dynamic> json) {
    return Hierarchy(
      retailer: Retailer.fromJson(json['retailer'] ?? {}),
      distributorChain: (json['distributorChain'] as List<dynamic>?)
          ?.map((e) => DistributorChain.fromJson(e))
          .toList() ?? [],
    );
  }
}

class Retailer {
  final String userId;
  final String name;
  final String userType;

  Retailer({
    required this.userId,
    required this.name,
    required this.userType,
  });

  factory Retailer.fromJson(Map<String, dynamic> json) {
    return Retailer(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      userType: json['userType'] ?? '',
    );
  }
}

class DistributorChain {
  final String id;
  final String userId;
  final String name;
  final String userType;
  final int level;

  DistributorChain({
    required this.id,
    required this.userId,
    required this.name,
    required this.userType,
    required this.level,
  });

  factory DistributorChain.fromJson(Map<String, dynamic> json) {
    return DistributorChain(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      userType: json['userType'] ?? '',
      level: json['level'] ?? 0,
    );
  }
}

class Dates {
  final DateTime? pickedDate;
  final DateTime? createdDate;
  final DateTime? lastModifiedDate;

  Dates({
    this.pickedDate,
    this.createdDate,
    this.lastModifiedDate,
  });

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      pickedDate: json['pickedDate'] != null 
          ? DateTime.tryParse(json['pickedDate']) 
          : null,
      createdDate: json['createdDate'] != null 
          ? DateTime.tryParse(json['createdDate']) 
          : null,
      lastModifiedDate: json['lastModifiedDate'] != null 
          ? DateTime.tryParse(json['lastModifiedDate']) 
          : null,
    );
  }
}