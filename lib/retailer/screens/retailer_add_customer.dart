import 'package:e_warranty/retailer/models/warranty_plans_model.dart';
import 'package:e_warranty/retailer/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

// Main Form Controller
class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
    late Future<List<WarrantyPlans>> _warrantyPlans;

  @override
  void initState() {
    super.initState();
    _warrantyPlans = fetchWarrantyPlans();
  }

  int _currentPage = 0;
  final PageController _pageController = PageController();

  static final Map<String, dynamic> _formData = {
    'customer': <String, String>{},
    'product': <String, String>{},
    'invoice': <String, dynamic>{
      'invoiceDate': DateTime.now(),
      'invoiceImage': null,
    },
    'images': <String, dynamic>{
      'frontImage': null, 
      'backImage': null, 
      'additionalImages': <String>[], 
    },
    'warranty': <String, dynamic>{
      'startDate': DateTime.now(),
      'expiryDate': DateTime.now(),
    },
  };

  final List<String> _pageTitles = [
    'Product Details',
    'Customer Info',
    'Invoice Details',
    'Product Images',
    'Warranty Info',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(_pageTitles[_currentPage]),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            height: 4,
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 5,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                ProductDetailsScreen(data: _formData['product']),
                CustomerDetailsScreen(data: _formData['customer']),
                InvoiceDetailsScreen(data: _formData['invoice']),
                ProductImagesScreen(data: _formData['images']),
                WarrantyDetailsScreen(data: _formData['warranty'],  warrantyPlansFuture: _warrantyPlans,),
              ],
            ),
          ),

          // Navigation
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousPage,
                      child: Text('Previous'),
                    ),
                  ),
                if (_currentPage > 0) SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _currentPage == 4 ? _submitForm : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _currentPage == 4 ? Colors.green : Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentPage == 4 ? 'Submit Form' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _submitForm() async {
    final combinedData = {
      "customerDetails": {
        "name": _formData['customer']['name'] ?? '',
        "email": _formData['customer']['email'] ?? '',
        "mobile": _formData['customer']['mobile'] ?? '',
        "alternateNumber": _formData['customer']['alternateNumber'] ?? '',
        "address": {
          "street": _formData['customer']['street'] ?? '',
          "city": _formData['customer']['city'] ?? '',
          "state": _formData['customer']['state'] ?? '',
          "country": _formData['customer']['country'] ?? '',
          "zipCode": _formData['customer']['zipCode'] ?? '',
        },
      },
      "productDetails": {
        "modelName": _formData['product']['modelName'] ?? '',
        "imei1": _formData['product']['imei1'] ?? '',
        "imei2": _formData['product']['imei2'] ?? '',
        "brand": _formData['product']['brand'] ?? '',
        "category": _formData['product']['category'] ?? '',
        "purchasePrice":
            double.tryParse(_formData['product']['purchasePrice'] ?? '') ?? 0,
      },
      "invoiceDetails": {
        "invoiceNumber": _formData['invoice']['invoiceNumber'] ?? '',
        "invoiceAmount":
            double.tryParse(
              _formData['invoice']['invoiceAmount']?.toString() ?? '',
            ) ??
            0,
        "invoiceImage":
            _formData['invoice']['invoiceImage'] ?? '', // Now a URL string
        "invoiceDate": DateFormat(
          'yyyy-MM-dd',
        ).format(_formData['invoice']['invoiceDate']),
      },
      "productImages": {
        "frontImage":
            _formData['images']['frontImage'] ?? '', // Now a URL string
        "backImage": _formData['images']['backImage'] ?? '', // Now a URL string
        "additionalImages":
            _formData['images']['additionalImages'] ??
            [], // Now list of URL strings
      },
      "warrantyDetails": {
        "planId": _formData['warranty']['planId'] ?? '',
        "planName": _formData['warranty']['planName'] ?? '',
        "warrantyPeriod":
            int.tryParse(
              _formData['warranty']['warrantyPeriod']?.toString() ?? '',
            ) ??
            0,
        "startDate": DateFormat(
          'yyyy-MM-dd',
        ).format(_formData['warranty']['startDate']),
        "expiryDate": DateFormat(
          'yyyy-MM-dd',
        ).format(_formData['warranty']['expiryDate']),
        "premiumAmount":
            double.tryParse(
              _formData['warranty']['premiumAmount']?.toString() ?? '',
            ) ??
            0,
      },
    };

    print("FORMDATA: $combinedData");

    try {
      final response = await submitCustomerData(combinedData);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final String message =
            decoded['message'] ?? 'Customer created successfully.';
      

        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Success!'),
                  content: Text(message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      } else {
        final errorMessage =
            decoded['error']?['message'] ?? 'Unknown error occurred.';
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

// File Upload Service
class FileUploadService {
  static const String baseUrl = 'https://boxer-patient-slowly.ngrok-free.app';
  static const String uploadEndpoint = '/api/customers/handle-file';

  static Future<String?> uploadFile(File file) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$uploadEndpoint'),
      );

      // Add the file
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Add mode parameter
      request.fields['mode'] = 'upload';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        String relativePath = jsonResponse['message'];
        return '$baseUrl$relativePath'; // Return full URL
      } else {
        print('Upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static Future<bool> deleteFile(String fileUrl) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$uploadEndpoint'),
      );

      // Add mode and deleteFile parameters
      request.fields['mode'] = 'delete';
      request.fields['deleteFile'] = fileUrl;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        return jsonResponse['message'] == 'deleted';
      } else {
        print('Delete failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }
}

// Individual Screen Components (Ultra Lightweight)
class ProductDetailsScreen extends StatelessWidget {
  final Map<String, String> data;

  ProductDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSimpleField('Model Name', 'modelName'),
          _buildSimpleField('IMEI 1', 'imei1', TextInputType.number),
          _buildSimpleField('IMEI 2 (Optional)', 'imei2', TextInputType.number),
          _buildSimpleField('Brand', 'brand'),
          _buildSimpleField('Category', 'category'),
          _buildSimpleField(
            'Purchase Price',
            'purchasePrice',
            TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleField(String label, String key, [TextInputType? type]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: type,
        onChanged: (value) => data[key] = value,
      ),
    );
  }
}

class CustomerDetailsScreen extends StatelessWidget {
  final Map<String, String> data;

  CustomerDetailsScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSimpleField('Full Name', 'name'),
          _buildSimpleField('Email', 'email', TextInputType.emailAddress),
          _buildSimpleField('Mobile Number', 'mobile', TextInputType.phone),
          _buildSimpleField(
            'Alternate Number',
            'alternateNumber',
            TextInputType.phone,
          ),
          _buildSimpleField('Street Address', 'street'),
          _buildSimpleField('City', 'city'),
          _buildSimpleField('State', 'state'),
          _buildSimpleField('Country', 'country'),
          _buildSimpleField('Zip Code', 'zipCode', TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildSimpleField(String label, String key, [TextInputType? type]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: type,
        onChanged: (value) => data[key] = value,
      ),
    );
  }
}

class InvoiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  InvoiceDetailsScreen({required this.data});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSimpleField('Invoice Number', 'invoiceNumber'),
          _buildSimpleField(
            'Invoice Amount',
            'invoiceAmount',
            TextInputType.number,
          ),
          SizedBox(height: 16),
          _buildImageSection(),
          SizedBox(height: 16),
          _buildDatePicker(),
        ],
      ),
    );
  }

  Widget _buildSimpleField(String label, String key, [TextInputType? type]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: type,
        onChanged: (value) => widget.data[key] = value,
      ),
    );
  }

  Widget _buildImageSection() {
    final String? imageUrl = widget.data['invoiceImage'];

    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child:
          _isUploading
              ? Center(child: CircularProgressIndicator())
              : imageUrl != null
              ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, color: Colors.red),
                              Text('Failed to load image'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white, size: 20),
                        onPressed: _deleteImage,
                        constraints: BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                    ),
                  ),
                ],
              )
              : InkWell(
                onTap: _pickImage,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Tap to select invoice image'),
                  ],
                ),
              ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.data['invoiceDate'],
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() => widget.data['invoiceDate'] = picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Invoice Date: ${DateFormat('yyyy-MM-dd').format(widget.data['invoiceDate'])}',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isUploading = true);

      final uploadedUrl = await FileUploadService.uploadFile(File(image.path));

      setState(() {
        _isUploading = false;
        if (uploadedUrl != null) {
          widget.data['invoiceImage'] = uploadedUrl;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to upload image')));
        }
      });
    }
  }

  Future<void> _deleteImage() async {
    final String? imageUrl = widget.data['invoiceImage'];
    if (imageUrl != null) {
      setState(() => _isUploading = true);

      final success = await FileUploadService.deleteFile(imageUrl);

      setState(() {
        _isUploading = false;
        if (success) {
          widget.data['invoiceImage'] = null;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete image')));
        }
      });
    }
  }
}

class ProductImagesScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  ProductImagesScreen({required this.data});

  @override
  State<ProductImagesScreen> createState() => _ProductImagesScreenState();
}

class _ProductImagesScreenState extends State<ProductImagesScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildImageSection('Front Image', 'frontImage'),
          SizedBox(height: 16),
          _buildImageSection('Back Image', 'backImage'),
          SizedBox(height: 24),
          Text(
            'Additional Images',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ..._buildAdditionalImages(),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isUploading ? null : _addAdditionalImage,
            icon: Icon(Icons.add),
            label: Text('Add Image'),
          ),
          if (_isUploading)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String label, String key) {
    final String? imageUrl = widget.data[key];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child:
              imageUrl != null
                  ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error, color: Colors.red),
                                  Text('Failed to load image'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () => _deleteImage(key),
                            constraints: BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.all(4),
                          ),
                        ),
                      ),
                    ],
                  )
                  : InkWell(
                    onTap: _isUploading ? null : () => _pickImage(key),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Tap to select $label'),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }

  List<Widget> _buildAdditionalImages() {
    final List<String> imageUrls = List<String>.from(
      widget.data['additionalImages'] ?? [],
    );
    return imageUrls.asMap().entries.map((entry) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    entry.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed:
                  _isUploading ? null : () => _removeAdditionalImage(entry.key),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _pickImage(String key) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isUploading = true);

      final uploadedUrl = await FileUploadService.uploadFile(File(image.path));

      setState(() {
        _isUploading = false;
        if (uploadedUrl != null) {
          widget.data[key] = uploadedUrl;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to upload image')));
        }
      });
    }
  }

  Future<void> _addAdditionalImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isUploading = true);

      final uploadedUrl = await FileUploadService.uploadFile(File(image.path));

      setState(() {
        _isUploading = false;
        if (uploadedUrl != null) {
          final List<String> imageUrls = List<String>.from(
            widget.data['additionalImages'] ?? [],
          );
          imageUrls.add(uploadedUrl);
          widget.data['additionalImages'] = imageUrls;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to upload image')));
        }
      });
    }
  }

  Future<void> _removeAdditionalImage(int index) async {
    final List<String> imageUrls = List<String>.from(
      widget.data['additionalImages'] ?? [],
    );

    if (index < imageUrls.length) {
      final imageUrl = imageUrls[index];
      setState(() => _isUploading = true);

      final success = await FileUploadService.deleteFile(imageUrl);

      setState(() {
        _isUploading = false;
        if (success) {
          imageUrls.removeAt(index);
          widget.data['additionalImages'] = imageUrls;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete image')));
        }
      });
    }
  }

  Future<void> _deleteImage(String key) async {
    final String? imageUrl = widget.data[key];
    if (imageUrl != null) {
      setState(() => _isUploading = true);

      final success = await FileUploadService.deleteFile(imageUrl);

      setState(() {
        _isUploading = false;
        if (success) {
          widget.data[key] = null;
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to delete image')));
        }
      });
    }
  }
}
class WarrantyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Future<List<WarrantyPlans>> warrantyPlansFuture;

  WarrantyDetailsScreen({
    required this.data,
    required this.warrantyPlansFuture,
  });

  @override
  State<WarrantyDetailsScreen> createState() => _WarrantyDetailsScreenState();
}

class _WarrantyDetailsScreenState extends State<WarrantyDetailsScreen> {
  WarrantyPlans? selectedPlan;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WarrantyPlans>>(
      future: widget.warrantyPlansFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: Text('Failed to load warranty plans.'));
        }

        final plans = snapshot.data!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Dropdown
              DropdownButtonFormField<WarrantyPlans>(
                decoration: InputDecoration(
                  labelText: 'Select Warranty Plan',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: selectedPlan,
                isExpanded: true,
                items: plans.map((plan) {
                  return DropdownMenuItem<WarrantyPlans>(
                    value: plan,
                    child: Text('${plan.planName} (${plan.duration} months, ₹${plan.premiumAmount})'),
                  );
                }).toList(),
                onChanged: (WarrantyPlans? plan) {
                  if (plan != null) {
                    setState(() {
                      selectedPlan = plan;

                      // Fill the fields with selected plan data
                      widget.data['planId'] = plan.planId;
                      widget.data['planName'] = plan.planName;
                      widget.data['warrantyPeriod'] = plan.duration;
                      widget.data['premiumAmount'] = plan.premiumAmount;
                    });
                  }
                },
              ),

              SizedBox(height: 16),

              _buildSimpleField('Plan ID', 'planId'),
              _buildSimpleField('Plan Name', 'planName'),
              _buildSimpleField('Warranty Period (months)', 'warrantyPeriod', TextInputType.number),
              _buildSimpleField('Premium Amount', 'premiumAmount', TextInputType.number),
              SizedBox(height: 16),
              _buildDatePicker('Start Date', 'startDate'),
              SizedBox(height: 16),
              _buildDatePicker('Expiry Date', 'expiryDate'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimpleField(String label, String key, [TextInputType? type]) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: TextEditingController(text: widget.data[key]?.toString() ?? '')
          ..selection = TextSelection.collapsed(offset: (widget.data[key]?.toString() ?? '').length),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        keyboardType: type,
        onChanged: (value) => widget.data[key] = value,
      ),
    );
  }

  Widget _buildDatePicker(String label, String key) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: widget.data[key],
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          setState(() => widget.data[key] = picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${DateFormat('yyyy-MM-dd').format(widget.data[key])}',
            ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
