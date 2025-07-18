import 'package:e_warranty/retailer/services/customer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class CustomerStepperForm extends StatefulWidget {
  @override
  _CustomerStepperFormState createState() => _CustomerStepperFormState();
}

class _CustomerStepperFormState extends State<CustomerStepperForm> {
  int _currentStep = 0;
  final _formKeys = List.generate(6, (_) => GlobalKey<FormState>());

  // Data holders
  final customerData = {
    "name": "",
    "email": "",
    "mobile": "",
    "alternateNumber": "",
    "street": "",
    "city": "",
    "state": "",
    "country": "",
    "zipCode": "",
  };

  final productData = {
    "modelName": "",
    "imei1": "",
    "imei2": "",
    "brand": "",
    "category": "",
    "purchasePrice": "",
  };

  final Map<String, dynamic> invoiceData = {
    "invoiceNumber": "",
    "invoiceAmount": "",
    "invoiceImage": "",
    "invoiceDate": DateTime.now(),
  };

  final Map<String, dynamic> productImagesData = {
    "frontImage": "",
    "backImage": "",
    "additionalImages": <String>[],
  };

  final Map<String, dynamic> warrantyData = {
    "planId": "",
    "planName": "",
    "warrantyPeriod": "",
    "startDate": DateTime.now(),
    "expiryDate": DateTime.now(),
    "premiumAmount": "",
  };

  final Map<String, dynamic> paymentData = {
    "paymentStatus": "PENDING",
    "paymentDate": DateTime.now(),
    "paymentMethod": "",
    "paymentOrderId": "",
    "paymentId": "",
    "transactionId": "",
  };

  // Controllers for additional images
  List<TextEditingController> additionalImageControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (var controller in additionalImageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _continue() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      _formKeys[_currentStep].currentState!.save();

      // Save additional images data
      if (_currentStep == 3) {
        productImagesData["additionalImages"] =
            additionalImageControllers
                .map((controller) => controller.text)
                .where((text) => text.isNotEmpty)
                .toList();
      }

      if (_currentStep < 5) {
        setState(() => _currentStep++);
      } else {
        _submitData();
      }
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitData() async{
    final combinedData = {
      "customerDetails": {
        "name": customerData["name"],
        "email": customerData["email"],
        "mobile": customerData["mobile"],
        "alternateNumber": customerData["alternateNumber"],
        "address": {
          "street": customerData["street"],
          "city": customerData["city"],
          "state": customerData["state"],
          "country": customerData["country"],
          "zipCode": customerData["zipCode"],
        },
      },
      "productDetails": {
        "modelName": productData["modelName"],
        "imei1": productData["imei1"],
        "imei2": productData["imei2"],
        "brand": productData["brand"],
        "category": productData["category"],
        "purchasePrice":
            double.tryParse(productData["purchasePrice"] ?? '') ?? 0,
      },
      "invoiceDetails": {
        "invoiceNumber": invoiceData["invoiceNumber"],
        "invoiceAmount": double.tryParse(invoiceData["invoiceAmount"]) ?? 0,
        "invoiceImage": invoiceData["invoiceImage"],
        "invoiceDate": DateFormat(
          'yyyy-MM-dd',
        ).format(invoiceData["invoiceDate"] as DateTime),
      },
      "productImages": {
        "frontImage": productImagesData["frontImage"],
        "backImage": productImagesData["backImage"],
        "additionalImages": productImagesData["additionalImages"],
      },
      "warrantyDetails": {
        "planId": warrantyData["planId"],
        "planName": warrantyData["planName"],
        "warrantyPeriod": int.tryParse(warrantyData["warrantyPeriod"]) ?? 0,
        "startDate": DateFormat(
          'yyyy-MM-dd',
        ).format(warrantyData["startDate"] as DateTime),
        "expiryDate": DateFormat(
          'yyyy-MM-dd',
        ).format(warrantyData["expiryDate"] as DateTime),
        "premiumAmount": double.tryParse(warrantyData["premiumAmount"]) ?? 0,
      },
      "paymentDetails": {
        "paymentStatus": paymentData["paymentStatus"],
        "paymentDate": DateFormat(
          'yyyy-MM-dd',
        ).format(paymentData["paymentDate"] as DateTime),
        "paymentMethod": paymentData["paymentMethod"],
        "paymentOrderId": paymentData["paymentOrderId"],
        "paymentId": paymentData["paymentId"],
        "transactionId": paymentData["transactionId"],
      },
    };

    print('=== COMPLETE FORM DATA ===');
    print(const JsonEncoder.withIndent('  ').convert(combinedData));
    print('=== END OF DATA ===');

    await submitCustomerData(combinedData);

    // Show success dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success!'),
            content: const Text(
              'Form submitted successfully. Check console for complete data.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Mobile number is required';
    if (value.length != 10) return 'Mobile number must be 10 digits';
    if (!RegExp(r'^[0-9]+$').hasMatch(value))
      return 'Mobile number must contain only digits';
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (double.tryParse(value) == null) return 'Please enter a valid number';
    return null;
  }

  Widget _buildTextField(
    String label,
    String key,
    Map<String, dynamic> data, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: type,
        inputFormatters: inputFormatters,
        validator:
            validator ??
            (val) => val == null || val.isEmpty ? '$label is required' : null,
        onSaved: (val) => data[key] = val!,
      ),
    );
  }

  Widget _buildDatePicker(String label, String key, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: data[key] as DateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => data[key] = picked);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(DateFormat('yyyy-MM-dd').format(data[key] as DateTime)),
        ),
      ),
    );
  }

  Widget _buildPaymentStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: paymentData["paymentStatus"],
        decoration: const InputDecoration(
          labelText: 'Payment Status',
          border: OutlineInputBorder(),
        ),
        items:
            ['PENDING', 'PAID', 'FAILED', 'REFUNDED'].map((status) {
              return DropdownMenuItem(value: status, child: Text(status));
            }).toList(),
        onChanged: (value) {
          setState(() {
            paymentData["paymentStatus"] = value!;
          });
        },
      ),
    );
  }

  Widget _buildAdditionalImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Images',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...additionalImageControllers.asMap().entries.map((entry) {
          int index = entry.key;
          TextEditingController controller = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Additional Image URL ${index + 1}',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      additionalImageControllers.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              additionalImageControllers.add(TextEditingController());
            });
          },
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add More Images'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade500, // dark neutral tone
            foregroundColor: Colors.white, // white text/icon
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
          ),
        ),
        const SizedBox(height: 8),
      
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Stepper Form'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _continue,
        onStepCancel: _cancel,
        onStepTapped: (step) => setState(() => _currentStep = step),
        controlsBuilder: (context, details) {
          return Row(
            children: [
              if (details.stepIndex < 5)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 10.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  child: const Text('Next'),
                ),

              if (details.stepIndex == 5)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 14.0,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text('Submit'),
                ),

              const SizedBox(width: 8),
              if (details.stepIndex > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Customer Details'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKeys[0],
              child: Column(
                children: [
                  _buildTextField('Name', 'name', customerData),
                  _buildTextField(
                    'Email',
                    'email',
                    customerData,
                    type: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  _buildTextField(
                    'Mobile',
                    'mobile',
                    customerData,
                    type: TextInputType.phone,
                    validator: _validateMobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  _buildTextField(
                    'Alternate Number',
                    'alternateNumber',
                    customerData,
                    type: TextInputType.phone,
                    validator: (value) => null, // Optional field
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),
                  _buildTextField('Street', 'street', customerData),
                  _buildTextField('City', 'city', customerData),
                  _buildTextField('State', 'state', customerData),
                  _buildTextField('Country', 'country', customerData),
                  _buildTextField(
                    'Zip Code',
                    'zipCode',
                    customerData,
                    type: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Product Details'),
            isActive: _currentStep >= 1,
            content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  _buildTextField('Model Name', 'modelName', productData),
                  _buildTextField(
                    'IMEI 1',
                    'imei1',
                    productData,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  _buildTextField(
                    'IMEI 2',
                    'imei2',
                    productData,
                    validator: (value) => null, // Optional field
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(15),
                    ],
                  ),
                  _buildTextField('Brand', 'brand', productData),
                  _buildTextField('Category', 'category', productData),
                  _buildTextField(
                    'Purchase Price',
                    'purchasePrice',
                    productData,
                    type: TextInputType.number,
                    validator:
                        (value) => _validateNumber(value, 'Purchase Price'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Invoice Details'),
            isActive: _currentStep >= 2,
            content: Form(
              key: _formKeys[2],
              child: Column(
                children: [
                  _buildTextField(
                    'Invoice Number',
                    'invoiceNumber',
                    invoiceData,
                  ),
                  _buildTextField(
                    'Invoice Amount',
                    'invoiceAmount',
                    invoiceData,
                    type: TextInputType.number,
                    validator:
                        (value) => _validateNumber(value, 'Invoice Amount'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                  ),
                  _buildTextField(
                    'Invoice Image URL',
                    'invoiceImage',
                    invoiceData,
                  ),
                  _buildDatePicker('Invoice Date', 'invoiceDate', invoiceData),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Product Images'),
            isActive: _currentStep >= 3,
            content: Form(
              key: _formKeys[3],
              child: Column(
                children: [
                  _buildTextField(
                    'Front Image URL',
                    'frontImage',
                    productImagesData,
                  ),
                  _buildTextField(
                    'Back Image URL',
                    'backImage',
                    productImagesData,
                  ),
                  const SizedBox(height: 16),
                  _buildAdditionalImagesSection(),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Warranty Details'),
            isActive: _currentStep >= 4,
            content: Form(
              key: _formKeys[4],
              child: Column(
                children: [
                  _buildTextField('Plan ID', 'planId', warrantyData),
                  _buildTextField('Plan Name', 'planName', warrantyData),
                  _buildTextField(
                    'Warranty Period (months)',
                    'warrantyPeriod',
                    warrantyData,
                    type: TextInputType.number,
                    validator:
                        (value) => _validateNumber(value, 'Warranty Period'),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _buildDatePicker('Start Date', 'startDate', warrantyData),
                  _buildDatePicker('Expiry Date', 'expiryDate', warrantyData),
                  _buildTextField(
                    'Premium Amount',
                    'premiumAmount',
                    warrantyData,
                    type: TextInputType.number,
                    validator:
                        (value) => _validateNumber(value, 'Premium Amount'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Payment Details'),
            isActive: _currentStep >= 5,
            content: Form(
              key: _formKeys[5],
              child: Column(
                children: [
                  _buildPaymentStatusDropdown(),
                  _buildDatePicker('Payment Date', 'paymentDate', paymentData),
                  _buildTextField(
                    'Payment Method',
                    'paymentMethod',
                    paymentData,
                  ),
                  _buildTextField(
                    'Payment Order ID',
                    'paymentOrderId',
                    paymentData,
                  ),
                  _buildTextField('Payment ID', 'paymentId', paymentData),
                  _buildTextField(
                    'Transaction ID',
                    'transactionId',
                    paymentData,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
