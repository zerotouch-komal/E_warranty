import 'package:e_warranty/models/warranty_model.dart';
import 'package:e_warranty/provider/login_provider.dart';
import 'package:e_warranty/services/warranty/warranty_service.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WarrantyPlan extends StatefulWidget {
  const WarrantyPlan({Key? key}) : super(key: key);

  @override
  State<WarrantyPlan> createState() => _WarrantyPlanState();
}

class _WarrantyPlanState extends State<WarrantyPlan> {
  List<Plan> plans = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  Future<void> _fetchPlans() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.authToken;

    if (token == null) {
      setState(() {
        errorMessage = 'Authentication token not found';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await PlanService.getPlans(token);

      if (mounted) {
        setState(() {
          if (response.success) {
            plans = response.plans;
            errorMessage = null;
          } else {
            errorMessage = response.message ?? 'Failed to fetch plans';
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error: $e';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        title: Text(
          'Warranty Plans',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil.unitHeight * 24),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: ScreenUtil.unitHeight * 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchPlans,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (plans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No Plans Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no warranty plans to display at the moment.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPlans,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          return _buildPlanCard(plans[index]);
        },
      ),
    );
  }

  Widget _buildPlanCard(Plan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.planName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.unitHeight * 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ScreenUtil.unitHeight * 6),
                      Text(
                        '${plan.duration} months coverage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil.unitHeight * 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.unitHeight * 20,
                    vertical: ScreenUtil.unitHeight * 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${plan.premiumAmount}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil.unitHeight * 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: ScreenUtil.unitHeight * 6),
                Text(
                  plan.planDescription,
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 18,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),

                SizedBox(height: ScreenUtil.unitHeight * 24),

                Text(
                  'Eligible Categories',
                  style: TextStyle(
                    fontSize: ScreenUtil.unitHeight * 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: ScreenUtil.unitHeight * 10),
                Wrap(
                  spacing: ScreenUtil.unitHeight * 10,
                  runSpacing: ScreenUtil.unitHeight * 10,
                  children:
                      plan.eligibleCategories.map((category) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.unitHeight * 14,
                            vertical: ScreenUtil.unitHeight * 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue.shade200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: ScreenUtil.unitHeight * 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: ScreenUtil.unitHeight * 20),

                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: ScreenUtil.unitHeight * 18,
                      color: Colors.grey[500],
                    ),
                    SizedBox(width: ScreenUtil.unitHeight * 8),
                    Text(
                      'Created ${_formatDate(plan.createdAt)}',
                      style: TextStyle(fontSize: ScreenUtil.unitHeight * 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}