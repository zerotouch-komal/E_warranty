class ParticularCustomerData {
  final CustomerDetails customerDetails;
  final ProductDetails productDetails;
  final InvoiceDetails invoiceDetails;
  final ProductImages productImages;
  final WarrantyDetails warrantyDetails;
  final CustomerDates dates;
  final String id;
  final String customerId;
  final String warrantyKey;
  final String companyId;
  final String retailerId;
  final int status;
  final bool isActive;
  final String notes;

  ParticularCustomerData({
    required this.customerDetails,
    required this.productDetails,
    required this.invoiceDetails,
    required this.productImages,
    required this.warrantyDetails,
    required this.dates,
    required this.id,
    required this.customerId,
    required this.warrantyKey,
    required this.companyId,
    required this.retailerId,
    required this.status,
    required this.isActive,
    required this.notes,
  });

  factory ParticularCustomerData.fromJson(Map<String, dynamic> json) {
    return ParticularCustomerData(
      customerDetails: CustomerDetails.fromJson(json['customerDetails']),
      productDetails: ProductDetails.fromJson(json['productDetails']),
      invoiceDetails: InvoiceDetails.fromJson(json['invoiceDetails']),
      productImages: ProductImages.fromJson(json['productImages']),
      warrantyDetails: WarrantyDetails.fromJson(json['warrantyDetails']),
      dates: CustomerDates.fromJson(json['dates']),
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      warrantyKey: json['warrantyKey'] ?? '',
      companyId: json['companyId'] ?? '',
      retailerId: json['retailerId'] ?? '',
      status: json['status'] ?? 0,
      isActive: json['isActive'] ?? false,
      notes: json['notes'] ?? '',
    );
  }
}

class CustomerDetails {
  final Address address;
  final String name;
  final String email;
  final String mobile;
  final String alternateNumber;

  CustomerDetails({
    required this.address,
    required this.name,
    required this.email,
    required this.mobile,
    required this.alternateNumber,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      address: Address.fromJson(json['address']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      alternateNumber: json['alternateNumber'] ?? '',
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
}

class ProductDetails {
  final String modelName;
  final String serialNumber;
  final int orignalWarranty;
  final String brand;
  final String category;
  final int purchasePrice;

  ProductDetails({
    required this.modelName,
    required this.serialNumber,
    required this.orignalWarranty,
    required this.brand,
    required this.category,
    required this.purchasePrice,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      modelName: json['modelName'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      orignalWarranty: json['orignalWarranty'] ?? 0,
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      purchasePrice: json['purchasePrice'] ?? 0,
    );
  }
}

class InvoiceDetails {
  final String invoiceNumber;
  final int invoiceAmount;
  final String invoiceImage;
  final DateTime invoiceDate;

  InvoiceDetails({
    required this.invoiceNumber,
    required this.invoiceAmount,
    required this.invoiceImage,
    required this.invoiceDate,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceAmount: json['invoiceAmount'] ?? 0,
      invoiceImage: json['invoiceImage'] ?? '',
      invoiceDate: DateTime.parse(json['invoiceDate']),
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
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
    );
  }
}

class WarrantyDetails {
  final String planId;
  final String planName;
  final int warrantyPeriod;
  final DateTime startDate;
  final DateTime expiryDate;
  final int premiumAmount;

  WarrantyDetails({
    required this.planId,
    required this.planName,
    required this.warrantyPeriod,
    required this.startDate,
    required this.expiryDate,
    required this.premiumAmount,
  });

  factory WarrantyDetails.fromJson(Map<String, dynamic> json) {
    return WarrantyDetails(
      planId: json['planId'] ?? '',
      planName: json['planName'] ?? '',
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      premiumAmount: json['premiumAmount'] ?? 0,
    );
  }
}

class CustomerDates {
  final DateTime? pickedDate;
  final DateTime createdDate;
  final DateTime lastModifiedDate;

  CustomerDates({
    required this.pickedDate,
    required this.createdDate,
    required this.lastModifiedDate,
  });

  factory CustomerDates.fromJson(Map<String, dynamic> json) {
    return CustomerDates(
      pickedDate:
          json['pickedDate'] != null
              ? DateTime.tryParse(json['pickedDate'])
              : null,
      createdDate: DateTime.parse(json['createdDate']),
      lastModifiedDate: DateTime.parse(json['lastModifiedDate']),
    );
  }
}
