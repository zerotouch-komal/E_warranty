import 'package:e_warranty/provider/wallet_provider.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wallet_history_model.dart';
import 'package:intl/intl.dart';

class WalletHistory extends StatefulWidget {
  const WalletHistory({super.key});

  @override
  State<WalletHistory> createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {
  String _selectedFilter = 'ALL';
  bool _isFilterLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<KeyHistoryProvider>(context, listen: false);
      if (!provider.hasLoadedOnce) {
        provider.getKeyHistory();
      } else {
        provider.refreshInBackground();
      }
    });
  }

  void _onFilterChanged(String filter) async {
    print('🔄 Filter changed to: $filter');
    
    setState(() {
      _selectedFilter = filter;
      _isFilterLoading = true;
    });

    try {
      final provider = Provider.of<KeyHistoryProvider>(context, listen: false);
      
      await provider.getKeyHistoryWithFilter(filter);
      
      print('✅ Data fetched successfully for filter: $filter');
    } catch (e) {
      print('❌ Error fetching data for filter $filter: $e'); 
    } finally {
      if (mounted) {
        setState(() {
          _isFilterLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Key History",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Filter",
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: ScreenUtil.unitHeight * 15),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.unitHeight * 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          items: ['ALL', 'ALLOCATION', 'WARRANTY_USAGE'].map((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.replaceAll('_', ' '),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _isFilterLoading ? null : (String? newValue) {
                            if (newValue != null) {
                              _onFilterChanged(newValue);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Consumer<KeyHistoryProvider>(
              builder: (context, provider, child) {
                if ((provider.isLoading && !provider.hasLoadedOnce) || _isFilterLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF2563EB),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: ScreenUtil.unitHeight * 20),
                        Text(
                          _isFilterLoading 
                              ? "Applying filter..."
                              : "Loading history...",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.historyList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.history,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No history available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.unitHeight * 20),
                        Text(
                          _selectedFilter == 'ALL'
                              ? "Your key transactions will appear here"
                              : "No ${_selectedFilter.toLowerCase().replaceAll('_', ' ')} transactions found",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.getKeyHistoryWithFilter(_selectedFilter);
                  },
                  color: const Color(0xFF2563EB),
                  child: ListView.builder(
                    padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                    itemCount: provider.historyList.length,
                    itemBuilder: (context, index) {
                      HistoryItem item = provider.historyList[index];
                      String formattedDate = DateFormat(
                        'MMM dd, yyyy • hh:mm a',
                      ).format(DateTime.parse(item.transactionDate).toLocal());

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300 + (index * 100)),
                        curve: Curves.easeOutBack,
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil.unitHeight * 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.all(
                                  ScreenUtil.unitHeight * 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                            ScreenUtil.unitHeight * 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF2563EB,
                                            ).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.history,
                                            color: const Color(0xFF2563EB),
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil.unitHeight * 20,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Date",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey[600],
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil.unitHeight * 5,
                                              ),
                                              Text(
                                                formattedDate,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1F2937),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.unitHeight * 20,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(
                                        ScreenUtil.unitHeight * 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "TYPE",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[600],
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      ScreenUtil.unitHeight * 5,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        ScreenUtil.unitHeight *
                                                        8,
                                                    vertical:
                                                        ScreenUtil.unitHeight *
                                                        4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: _getTypeColor(
                                                      item.walletTransactionType,
                                                    ).withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    item.walletTransactionType,
                                                    style: TextStyle(
                                                      fontSize:
                                                          ScreenUtil
                                                              .unitHeight *
                                                          12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: _getTypeColor(
                                                        item.walletTransactionType,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: ScreenUtil.unitHeight * 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "AMOUNT",
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil.unitHeight *
                                                        11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[600],
                                                    letterSpacing: 0.8,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(
                                                        ScreenUtil.unitHeight *
                                                            6,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFF059669,
                                                        ).withOpacity(0.1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .currency_rupee_sharp,
                                                        color: Color(
                                                          0xFF059669,
                                                        ),
                                                        size:
                                                            ScreenUtil
                                                                .unitHeight *
                                                            12,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          ScreenUtil
                                                              .unitHeight *
                                                          8,
                                                    ),
                                                    Text(
                                                      item.amount.toString(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            ScreenUtil
                                                                .unitHeight *
                                                            14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xFF1F2937,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil.unitHeight * 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.vpn_key,
                                          size: ScreenUtil.unitHeight * 16,
                                          color: Colors.grey[500],
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          item.walletTransactionId,
                                          style: TextStyle(
                                            fontSize:
                                                ScreenUtil.unitHeight * 14,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String walletTransactionType) {
    switch (walletTransactionType.toLowerCase()) {
      case 'allocation':
        return const Color(0xFF2563EB);
      case 'warranty_usage':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }
}