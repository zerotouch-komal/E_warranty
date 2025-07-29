import 'package:e_warranty/retailer/models/history_model.dart';
import 'package:e_warranty/retailer/screens/retailer_drawer.dart';
import 'package:e_warranty/retailer/services/history_service.dart';
import 'package:flutter/material.dart';

class HistoryData extends StatefulWidget {
  const HistoryData({super.key});

  @override
  State<HistoryData> createState() => _HistoryDataState();
}

class _HistoryDataState extends State<HistoryData> {
  late Future<List<RetailerHistoryData>> _retailerHistoryFuture;
  List<RetailerHistoryData> _allHistoryData = [];
  List<RetailerHistoryData> _filteredHistoryData = [];
  String _selectedSortOption = 'ALL';

  final List<String> _sortOptions = [
    'ALL',
    'ALLOCATION',
    'WARRANTY_USAGE',
    'REVOKE',
    'REFUND',
  ];

  @override
  void initState() {
    super.initState();
    _retailerHistoryFuture = fetchRetailerHistoryData();
    _loadData();
  }

  void _loadData() async {
    try {
      final data = await fetchRetailerHistoryData();
      setState(() {
        _allHistoryData = data;
        _filteredHistoryData = _sortAndFilterData(data, _selectedSortOption);
      });
    } catch (e) {
      // Handle error
      print('Error loading data: $e');
    }
  }

  List<RetailerHistoryData> _sortAndFilterData(
    List<RetailerHistoryData> data,
    String sortOption,
  ) {
    List<RetailerHistoryData> filtered = data;

    // Filter by transaction type if not "ALL"
    if (sortOption != 'ALL') {
      filtered =
          data.where((item) => item.transactionType == sortOption).toList();
    }

    // Sort by transaction date in descending order (latest first)
    filtered.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    return filtered;
  }

  void _onSortOptionChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedSortOption = value;
        _filteredHistoryData = _sortAndFilterData(_allHistoryData, value);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getTransactionTypeColor(String transactionType) {
    switch (transactionType) {
      case 'ALLOCATION':
        return Colors.green;
      case 'WARRANTY_USAGE':
        return Colors.red;
      case 'REVOKE':
        return Colors.orange;
      case 'REFUND':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionTypeIcon(String transactionType) {
    switch (transactionType) {
      case 'ALLOCATION':
        return Icons.add_circle;
      case 'WARRANTY_USAGE':
        return Icons.build;
      case 'REVOKE':
        return Icons.remove_circle;
      case 'REFUND':
        return Icons.money_off;
      default:
        return Icons.swap_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          // Sort Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.deepPurple),
                const SizedBox(width: 8),
                const Text(
                  'Filter by ',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSortOption,
                        onChanged: _onSortOptionChanged,
                        isExpanded: true,
                        items:
                            _sortOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color:
                                        option == 'ALL'
                                            ? Colors.black87
                                            : _getTransactionTypeColor(option),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Data List Section
          Expanded(
            child: FutureBuilder<List<RetailerHistoryData>>(
              future: _retailerHistoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.deepPurple),
                        SizedBox(height: 16),
                        Text('Loading history data...'),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _retailerHistoryFuture =
                                  fetchRetailerHistoryData();
                            });
                            _loadData();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || _filteredHistoryData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _selectedSortOption == 'ALL'
                              ? 'No history data found.'
                              : 'No $_selectedSortOption transactions found.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadData();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredHistoryData.length,
                      itemBuilder: (context, index) {
                        final history = _filteredHistoryData[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.white, Colors.grey[50]!],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header Row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getTransactionTypeColor(
                                            history.transactionType,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: _getTransactionTypeColor(
                                              history.transactionType,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              _getTransactionTypeIcon(
                                                history.transactionType,
                                              ),
                                              size: 16,
                                              color: _getTransactionTypeColor(
                                                history.transactionType,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              history.transactionType,
                                              style: TextStyle(
                                                color: _getTransactionTypeColor(
                                                  history.transactionType,
                                                ),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        history.transactionType ==
                                                "WARRANTY_USAGE"
                                            ? '-₹${history.amount}'
                                            : '₹${history.amount}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: _getTransactionTypeColor(
                                            history.transactionType,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Customer Information
                                  if (history.transactionType ==
                                      "WARRANTY_USAGE")
                                    _buildInfoRow(
                                      'Customer Name',
                                      history.customerDetails?.customerName ??
                                          'n/a',
                                      Icons.person,
                                    ),

                                  const SizedBox(height: 8),

                                  // Warranty Key
                                  if (history.transactionType ==
                                      "WARRANTY_USAGE")
                                    _buildInfoRow(
                                      'Warranty Key',
                                      history.warrantyKey ?? 'n/a',
                                      Icons.vpn_key,
                                    ),

                                  if (history.transactionType == "ALLOCATION")
                                    _buildInfoRow(
                                      'Transaction Id',
                                      history.transactionId,
                                      Icons.vpn_key,
                                    ),

                                  const SizedBox(height: 8),

                                  // User Types Row
                                  Row(
                                    children: [
                                      if (history.transactionType ==
                                          "ALLOCATION")
                                        Expanded(
                                          child: _buildInfoRow(
                                            'From',
                                            history.fromUser != null
                                                ? '${history.fromUser!.name} (${history.fromUser!.userType})'
                                                : 'n/a',
                                            Icons.person_outline,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoRow(
                                          'Notes',
                                          history.notes ?? "n/a",
                                          Icons.notes,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Date
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatDate(history.transactionDate),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
