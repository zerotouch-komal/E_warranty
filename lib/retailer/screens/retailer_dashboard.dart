import 'package:e_warranty/provider/login_provider.dart';
import 'package:e_warranty/retailer/models/dashboard_model.dart';
import 'package:e_warranty/retailer/screens/retailer_add_customer.dart';
import 'package:e_warranty/retailer/screens/retailer_drawer.dart';
import 'package:e_warranty/retailer/screens/retailer_customers_list.dart';
import 'package:e_warranty/retailer/services/dashboard_service.dart';
import 'package:e_warranty/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EWarrantyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Warranty Retailer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1565C0), // Darker blue
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0D47A1), // Very dark blue
        ),
      ),
      home: RetailerDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RetailerDashboard extends StatefulWidget {
  @override
  _RetailerDashboardState createState() => _RetailerDashboardState();
}

class _RetailerDashboardState extends State<RetailerDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<DashboardData> dashboardData;

  @override
  void initState() {
    super.initState();
    dashboardData = fetchRetailerDashboardStats();
    print('dashboardData $dashboardData');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Color(0xFF0D47A1)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF0D47A1)),
            onPressed: () {
              _refreshDashboard();
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Color(0xFF0D47A1)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF0D47A1)),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: FutureBuilder<DashboardData>(
        future: dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Color(0xFF1565C0)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error loading dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      alignment: Alignment.center,
                      child: Text(
                        'Please try refreshing the page or log out and log back in.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return _buildDashboardContent(context, snapshot.data!);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, DashboardData data) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final padding = isTablet ? 24.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wallet Statistics Section
          _buildWalletSection(context, data.walletBalance, isTablet),
          SizedBox(height: 16),

          _buildEWarrantyStatsSection(context, data.eWarrantyStats, isTablet),
          SizedBox(height: 16),

          // Customer Count Section
          _buildCustomerCountSection(
            context,
            data.totalCustomersCount,
            isTablet,
          ),
          SizedBox(height: 24),

          _buildActionButtons(),

          SizedBox(height: 24),

          // Recent Customers Section
          _buildRecentCustomersSection(context, data.customers, isTablet),
        ],
      ),
    );
  }

  Widget _buildEWarrantyStatsSection(
    BuildContext context,
    EWarrantyStats stats,
    bool isTablet,
  ) {
    // Responsive font sizing
    final double titleFontSize = isTablet ? 16 : 11.5;
    final double valueFontSize = isTablet ? 20 : 18;
    final double headerFontSize = isTablet ? 22 : 18;
    final double iconSize = isTablet ? 28 : 24;

    final textStyleTitle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: titleFontSize,
      color: Colors.grey[700],
      letterSpacing: 0.3,
    );

    final textStyleValue = TextStyle(
      fontSize: valueFontSize,
      fontWeight: FontWeight.w700,
      color: Colors.grey[900],
      letterSpacing: 0.2,
    );

    Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
    ) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: textStyleValue),
                  Container(
                    padding: EdgeInsets.all(isTablet ? 12 : 10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: iconSize),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 16 : 12),
              Text(
                title,
                style: textStyleTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 6,
        vertical: isTablet ? 16 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Statistics",
            style: TextStyle(
              fontSize: headerFontSize,
              fontWeight: FontWeight.w700,
              color: Colors.blue[900],
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive grid parameters
              double screenWidth = constraints.maxWidth;
              double cardSpacing = isTablet ? 16 : 12;
              double cardWidth = (screenWidth - cardSpacing) / 2;
              double cardHeight = isTablet ? 140 : 120;
              double aspectRatio = cardWidth / cardHeight;

              return GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: cardSpacing,
                mainAxisSpacing: cardSpacing,
                childAspectRatio: aspectRatio,
                children: [
                  _buildStatCard(
                    "Total Warranties",
                    stats.totalWarranties.toString(),
                    Icons.description_outlined,
                    Color(0xFF2563EB),
                  ),
                  _buildStatCard(
                    "Active Warranties",
                    stats.activeWarranties.toString(),
                    Icons.verified_outlined,
                    Color(0xFF059669),
                  ),
                  _buildStatCard(
                    "Expired Warranties",
                    stats.expiredWarranties.toString(),
                    Icons.schedule_outlined,
                    Color(0xFFDC2626),
                  ),
                  _buildStatCard(
                    "Claimed Warranties",
                    stats.claimedWarranties.toString(),
                    Icons.task_alt_outlined,
                    Color(0xFFEA580C),
                  ),
                  _buildStatCard(
                    "Premium Collected",
                    "₹${stats.totalPremiumCollected}",
                    Icons.account_balance_wallet_outlined,
                    Color(0xFF7C3AED),
                  ),
                  _buildStatCard(
                    "Last Warranty",
                    stats.lastWarrantyDate != null
                        ? "${stats.lastWarrantyDate!.day}/${stats.lastWarrantyDate!.month}/${stats.lastWarrantyDate!.year}"
                        : "N/A",
                    Icons.event_outlined,
                    Color(0xFF0891B2),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection(
    BuildContext context,
    WalletBalance wallet,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.all(2),
      child: _buildRemainingCard(
        'Wallet Balance',
        '₹${_formatAmount(wallet.remainingAmount)}',
        Icons.savings,
        Colors.green.shade600,
        Colors.green.shade50,
      ),
    );
  }

  Widget _buildRemainingCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Balance Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Icon on right
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D47A1),
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                title: 'Add Customer',
                icon: Icons.person_add_rounded,
                color: Color(0xFF2E7D32),
                bgColor: Color(0xFFE8F5E8),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerStepperForm(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                title: 'View Customers',
                icon: Icons.people_rounded,
                color: Color(0xFF1565C0),
                bgColor: Color(0xFFE3F2FD),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RetailerViewCustomers(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                title: 'View\nClaims',
                icon: Icons.assignment_rounded,
                color: Color(0xFFE65100),
                bgColor: Color(0xFFFFF3E0),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: Colors.grey.shade200, width: 1),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF0D47A1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCountSection(
    BuildContext context,
    int totalCustomers,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.people, size: 32, color: Colors.purple.shade600),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  totalCustomers.toString(),
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  'Total Customers',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Color(0xFF1565C0),
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

  Widget _buildRecentCustomersSection(
    BuildContext context,
    List<Customer> customers,
    bool isTablet,
  ) {
    // Show only the first 10 customers
    final recentCustomers = customers.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Customers',
              style: TextStyle(
                fontSize: isTablet ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (recentCustomers.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.grey.shade200,
                ),
                SizedBox(height: 16),
                Text(
                  'No customers found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentCustomers.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildCustomerCard(recentCustomers[index], isTablet);
            },
          ),
      ],
    );
  }

  Widget _buildCustomerCard(Customer customer, bool isTablet) {
    final formattedDate = DateFormat(
      'MMM dd, yyyy • hh:mm a',
    ).format(customer.createdDate);
    final premiumAmount =
        customer.premiumAmount is int ? customer.premiumAmount as int : 0;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.person, size: 20, color: Color(0xFF1565C0)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.customerName.isNotEmpty
                          ? customer.customerName
                          : 'Unknown Customer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      customer.warrantyKey,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  Icons.category,
                  customer.category.isNotEmpty ? customer.category : 'N/A',
                  Colors.blue.shade50,
                  Colors.blue.shade600,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildInfoChip(
                  Icons.devices,
                  customer.modelName.isNotEmpty ? customer.modelName : 'N/A',
                  Colors.orange.shade50,
                  Colors.orange.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Spacer(), // pushes the amount to the right
              if (premiumAmount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade200, width: 1),
                  ),
                  child: Text(
                    '₹${_formatAmount(premiumAmount)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      "Notes: ",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 200, // adjust as needed
                      child: Text(
                        customer.notes?.isNotEmpty == true
                            ? customer.notes!
                            : "n/a",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightGreen.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String text,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    return NumberFormat('#,##,###').format(amount);
  }

  void _refreshDashboard() {
    setState(() {
      dashboardData = fetchRetailerDashboardStats();
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFF0D47A1),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Color(0xFF1565C0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF1565C0))),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                navigator.pop(); // Close the dialog

                final success =
                    await Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    ).logoutWithoutNavigation();

                if (!mounted) return;

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Logged out successfully'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
