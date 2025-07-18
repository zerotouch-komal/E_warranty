import 'package:e_warranty/provider/key_provider.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/key_history_model.dart';
import 'package:intl/intl.dart';

class KeyHistoryScreen extends StatefulWidget {
  const KeyHistoryScreen({super.key});

  @override
  State<KeyHistoryScreen> createState() => _KeyHistoryScreenState();
}

class _KeyHistoryScreenState extends State<KeyHistoryScreen> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Key History",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      
      body: Consumer<KeyHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && !provider.hasLoadedOnce) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 20),
                  Text(
                    "Loading history...",
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
                    "Your key transactions will appear here",
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
              await provider.getKeyHistory();
            },
            color: const Color(0xFF2563EB),
            child: ListView.builder(
              padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
              itemCount: provider.historyList.length,
              itemBuilder: (context, index) {
                HistoryItem item = provider.historyList[index];
                String formattedDate = DateFormat('MMM dd, yyyy • hh:mm a')
                    .format(DateTime.parse(item.transactionDate).toLocal());

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutBack,
                  child: Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil.unitHeight * 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          
                        },
                        child: Padding(
                          padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(ScreenUtil.unitHeight * 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2563EB).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.history,
                                      color: const Color(0xFF2563EB),
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil.unitHeight * 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                        SizedBox(height: ScreenUtil.unitHeight * 5),
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
                              SizedBox(height: ScreenUtil.unitHeight * 20),
                              Container(
                                padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                          SizedBox(height: ScreenUtil.unitHeight * 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil.unitHeight * 5,
                                              vertical: ScreenUtil.unitHeight * 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getTypeColor(item.keyType).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.keyType,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: _getTypeColor(item.keyType),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil.unitHeight * 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "COUNT",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(ScreenUtil.unitHeight * 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF059669).withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.numbers,
                                                  color: Color(0xFF059669),
                                                  size: 12,
                                                ),
                                              ),
                                              SizedBox(width: ScreenUtil.unitHeight * 10),
                                              Text(
                                                item.keyCount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1F2937),
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
                              SizedBox(height: ScreenUtil.unitHeight * 20),
                              Row(
                                children: [
                                  Icon(
                                    Icons.vpn_key,
                                    size: 16,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    item.keyId,
                                    style: TextStyle(
                                      fontSize: 13,
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
    );
  }

  Color _getTypeColor(String keyType) {
    switch (keyType.toLowerCase()) {
      case 'premium':
        return const Color(0xFF7C3AED);
      case 'standard':
        return const Color(0xFF2563EB);
      case 'basic':
        return const Color(0xFF059669);
      case 'trial':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF6B7280);
    }
  }
}