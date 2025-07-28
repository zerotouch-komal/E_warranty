import 'package:e_warranty/models/customer_detail.dart';
import 'package:e_warranty/provider/customer_provider.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomerDetailScreen extends StatefulWidget {
  final String customerId;

  const CustomerDetailScreen({Key? key, required this.customerId})
    : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerDetailProvider>().fetchCustomerDetail(
        customerId: widget.customerId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Customer Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
      body: Consumer<CustomerDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  Text(
                    'Error',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 10),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: ScreenUtil.unitHeight * 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 26),
                  ElevatedButton(
                    onPressed:
                        () => provider.refreshCustomerDetail(
                          customerId: widget.customerId,
                        ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.unitHeight * 26,
                        vertical: ScreenUtil.unitHeight * 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.customerDetail == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off_outlined,
                    size: ScreenUtil.unitHeight * 70,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  Text(
                    'No Customer Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh:
                () => provider.refreshCustomerDetail(
                  customerId: widget.customerId,
                ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(ScreenUtil.unitHeight * 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(provider.customerDetail!),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildCustomerDetailsCard(
                    provider.customerDetail!.customerDetails,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildProductDetailsCard(
                    provider.customerDetail!.productDetails,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildWarrantyDetailsCard(
                    provider.customerDetail!.warrantyDetails,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildPaymentDetailsCard(
                    provider.customerDetail!.paymentDetails,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildInvoiceDetailsCard(
                    provider.customerDetail!.invoiceDetails,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildProductImagesCard(
                    provider.customerDetail!.productImages,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 18),
                  _buildHierarchyCard(provider.customerDetail!.hierarchy),
                  if (provider.customerDetail!.notes.isNotEmpty) ...[
                    SizedBox(height: ScreenUtil.unitHeight * 18),
                    _buildNotesCard(provider.customerDetail!.notes),
                  ],
                  SizedBox(height: ScreenUtil.unitHeight * 26),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(CustomerDetail customer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[600]!, Colors.blue[400]!],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil.unitHeight * 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: ScreenUtil.unitHeight * 26,
                  ),
                ),
                SizedBox(width: ScreenUtil.unitHeight * 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.customerDetails.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.unitHeight * 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.unitHeight * 14,
                    vertical: ScreenUtil.unitHeight * 8,
                  ),
                  decoration: BoxDecoration(
                    color: customer.isActive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    customer.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.unitHeight * 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.unitHeight * 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderInfo(
                  'Warranty Key',
                  customer.warrantyKey,
                  Icons.security,
                ),
                SizedBox(height: ScreenUtil.unitHeight * 18),
                _buildHeaderInfo(
                  'Status',
                  _getStatusText(customer.status),
                  Icons.info,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil.unitHeight * 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: ScreenUtil.unitHeight * 18),
              SizedBox(width: ScreenUtil.unitHeight * 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: ScreenUtil.unitHeight * 14,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.unitHeight * 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.unitHeight * 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsCard(CustomerDetails details) {
    return _buildSectionCard('Customer Information', Icons.person_outline, [
      _buildInfoRow('Name', details.name, Icons.person),
      _buildInfoRow('Email', details.email, Icons.email),
      _buildInfoRow('Mobile', details.mobile, Icons.phone),
      if (details.alternateNumber.isNotEmpty)
        _buildInfoRow(
          'Alternate Number',
          details.alternateNumber,
          Icons.phone_outlined,
        ),
      _buildInfoRow('Address', details.address.fullAddress, Icons.location_on),
    ]);
  }

  Widget _buildProductDetailsCard(ProductDetails details) {
    return _buildSectionCard('Product Information', Icons.devices, [
      _buildInfoRow('Model', details.modelName, Icons.smartphone),
      _buildInfoRow('Brand', details.brand, Icons.business),
      _buildInfoRow('Category', details.category, Icons.category),
      if (details.imei1.isNotEmpty)
        _buildInfoRow('IMEI 1', details.imei1, Icons.fingerprint),
      if (details.imei2.isNotEmpty)
        _buildInfoRow('IMEI 2', details.imei2, Icons.fingerprint),
      if (details.purchasePrice > 0)
        _buildInfoRow(
          'Purchase Price',
          '₹${details.purchasePrice.toStringAsFixed(2)}',
          Icons.currency_rupee,
        ),
      if (details.originalWarranty > 0)
        _buildInfoRow(
          'Original Warranty',
          '${details.originalWarranty} months',
          Icons.schedule,
        ),
    ]);
  }

  Widget _buildWarrantyDetailsCard(WarrantyDetails details) {
    final isExpired = details.isExpired;
    final daysRemaining = details.daysRemaining;

    return _buildSectionCard('Warranty Information', Icons.shield_outlined, [
      if (details.planName.isNotEmpty)
        _buildInfoRow('Plan Name', details.planName, Icons.article),
      if (details.warrantyPeriod > 0)
        _buildInfoRow(
          'Warranty Period',
          '${details.warrantyPeriod} months',
          Icons.schedule,
        ),
      if (details.startDate != null)
        _buildInfoRow(
          'Start Date',
          _formatDate(details.startDate!),
          Icons.play_arrow,
        ),
      if (details.expiryDate != null)
        _buildInfoRow(
          'Expiry Date',
          _formatDate(details.expiryDate!),
          Icons.stop,
        ),
      if (details.premiumAmount > 0)
        _buildInfoRow(
          'Premium Amount',
          '₹${details.premiumAmount.toStringAsFixed(2)}',
          Icons.currency_rupee,
        ),
      if (details.expiryDate != null)
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: isExpired ? Colors.red[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isExpired ? Colors.red[200]! : Colors.green[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isExpired ? Icons.warning : Icons.check_circle,
                color: isExpired ? Colors.red : Colors.green,
                size: ScreenUtil.unitHeight * 22,
              ),
              SizedBox(width: ScreenUtil.unitHeight * 8),
              Expanded(
                child: Text(
                  isExpired
                      ? 'Warranty Expired'
                      : '$daysRemaining days remaining',
                  style: TextStyle(
                    color: isExpired ? Colors.red[700] : Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
    ]);
  }

  Widget _buildPaymentDetailsCard(PaymentDetails details) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.pending;

    switch (details.paymentStatus.toLowerCase()) {
      case 'completed':
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'failed':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
    }

    return _buildSectionCard('Payment Information', Icons.payment, [
      Container(
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 14),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: statusColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: ScreenUtil.unitHeight * 22),
            SizedBox(width: ScreenUtil.unitHeight * 8),
            Text(
              'Status: ${details.paymentStatus}',
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      SizedBox(height: ScreenUtil.unitHeight * 8),
      if (details.paymentMethod.isNotEmpty)
        _buildInfoRow(
          'Payment Method',
          details.paymentMethod,
          Icons.credit_card,
        ),
      if (details.paymentDate != null)
        _buildInfoRow(
          'Payment Date',
          _formatDate(details.paymentDate!),
          Icons.date_range,
        ),
      if (details.orderId.isNotEmpty)
        _buildInfoRow('Order ID', details.orderId, Icons.receipt),
      if (details.transactionId.isNotEmpty)
        _buildInfoRow(
          'Transaction ID',
          details.transactionId,
          Icons.receipt_long,
        ),
    ]);
  }

  Widget _buildInvoiceDetailsCard(InvoiceDetails details) {
    return _buildSectionCard('Invoice Information', Icons.receipt_outlined, [
      if (details.invoiceNumber.isNotEmpty)
        _buildInfoRow('Invoice Number', details.invoiceNumber, Icons.numbers),
      if (details.invoiceAmount > 0)
        _buildInfoRow(
          'Invoice Amount',
          '₹${details.invoiceAmount.toStringAsFixed(2)}',
          Icons.currency_rupee,
        ),
      if (details.invoiceDate != null)
        _buildInfoRow(
          'Invoice Date',
          _formatDate(details.invoiceDate!),
          Icons.date_range,
        ),
      if (details.invoiceImage.isNotEmpty)
        Container(
          margin: EdgeInsets.only(top: ScreenUtil.unitHeight * 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Invoice Image',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: ScreenUtil.unitHeight * 8),
              GestureDetector(
                onTap: () => _showImageDialog(details.invoiceImage),
                child: Container(
                  height: ScreenUtil.unitHeight * 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      details.invoiceImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    ]);
  }

  Widget _buildProductImagesCard(ProductImages images) {
    final allImages = images.allImages;
    if (allImages.isEmpty) return SizedBox.shrink();

    return _buildSectionCard('Product Images', Icons.image_outlined, [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: allImages.length,
        itemBuilder: (context, index) {
          final image = allImages[index];
          String label = 'Additional';
          if (index == 0 && images.frontImage.isNotEmpty)
            label = 'Front';
          else if (index == 1 && images.backImage.isNotEmpty)
            label = 'Back';

          return GestureDetector(
            onTap: () => _showImageDialog(image),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: ScreenUtil.unitHeight * 26,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(ScreenUtil.unitHeight * 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ScreenUtil.unitHeight * 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildHierarchyCard(Hierarchy hierarchy) {
    return _buildSectionCard('Business Hierarchy', Icons.account_tree, [
      Container(
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 14),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.store, color: Colors.blue[600], size: ScreenUtil.unitHeight * 22),
                SizedBox(width: ScreenUtil.unitHeight * 10),
                Text(
                  'Retailer',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil.unitHeight * 16),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.unitHeight * 18),
            Text(
              hierarchy.retailer.name,
              style: TextStyle(fontSize: ScreenUtil.unitHeight * 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Type: ${hierarchy.retailer.userType}',
              style: TextStyle(fontSize: ScreenUtil.unitHeight * 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      if (hierarchy.distributorChain.isNotEmpty) ...[
        SizedBox(height: ScreenUtil.unitHeight * 18),
        const Text(
          'Company',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 10),
        ...hierarchy.distributorChain.map((distributor) {
          return Container(
            margin: EdgeInsets.only(bottom: ScreenUtil.unitHeight * 10),
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 14),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil.unitHeight * 8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'L${distributor.level}',
                    style: TextStyle(
                      fontSize: ScreenUtil.unitHeight * 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
                SizedBox(width: ScreenUtil.unitHeight * 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        distributor.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil.unitHeight * 16,
                        ),
                      ),
                      Text(
                        distributor.userType,
                        style: TextStyle(fontSize: ScreenUtil.unitHeight * 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ]);
  }

  Widget _buildNotesCard(String notes) {
    return _buildSectionCard('Notes', Icons.note_outlined, [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 18),
        decoration: BoxDecoration(
          color: Colors.yellow[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.yellow[200]!),
        ),
        child: Text(notes, style: TextStyle(fontSize: ScreenUtil.unitHeight * 16, height: 1.5)),
      ),
    ]);
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(ScreenUtil.unitHeight * 10),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue[600], size: ScreenUtil.unitHeight * 22),
                ),
                  SizedBox(width: ScreenUtil.unitHeight * 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.unitHeight * 18),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    if (value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil.unitHeight * 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: ScreenUtil.unitHeight * 20, color: Colors.grey[600]),
          SizedBox(width: ScreenUtil.unitHeight * 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ScreenUtil.unitHeight * 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.all(ScreenUtil.unitHeight * 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          padding: EdgeInsets.all(ScreenUtil.unitHeight * 50),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: ScreenUtil.unitHeight * 70,
                                color: Colors.grey,
                              ),
                              SizedBox(height: ScreenUtil.unitHeight * 18),
                              Text(
                                'Failed to load image',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: ScreenUtil.unitHeight * 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 40,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil.unitHeight * 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: ScreenUtil.unitHeight * 26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Inactive';
      case 1:
        return 'Active';
      case 2:
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
}
