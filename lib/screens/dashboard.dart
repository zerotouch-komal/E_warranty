import 'package:e_warranty/provider/dashboard_provider.dart';
import 'package:e_warranty/screens/key_history.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<DashboardProvider>(
          context,
          listen: false,
        ).loadDashboardStats();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        shadowColor: Colors.black12,
        title: Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: ScreenUtil.unitHeight * 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notifications',
            onPressed: () {
              
            },
          ),
        ],
      ),

      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
              ),
            );
          }

          final stats = provider.stats;
          if (stats == null) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: ScreenUtil.unitHeight * 20, color: Colors.grey[600]),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKeyStatistics(context),

                SizedBox(height: 32),

                _buildUserTypeGrid(stats),

                SizedBox(height: 32),

                _buildTableSection(stats),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyStatistics(BuildContext context) {
    final stats = Provider.of<DashboardProvider>(context, listen: false).stats;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Statistics',
                style: TextStyle(
                  fontSize: ScreenUtil.unitHeight * 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KeyHistoryScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.history, size: 18),
                label: const Text('View History'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue[600],
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.unitHeight * 20,
                    vertical: ScreenUtil.unitHeight * 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(ScreenUtil.unitHeight * 24),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Keys',
                    stats?.keyAllocation.remainingKeys.toString() ?? '0',
                    Colors.orange[400]!,
                    Icons.dashboard,
                  ),
                ),
                Container(
                  width: 1,
                  height: ScreenUtil.unitHeight * 20,
                  color: Colors.grey[200],
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil.unitHeight * 20),
                ),
                Expanded(
                  child: _buildStatCard(
                    'Used',
                    stats?.keyAllocation.usedKeys.toString() ?? '0',
                    Colors.green[400]!,
                    Icons.check_circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 20),
        Text(
          value,
          style: TextStyle(
            fontSize: ScreenUtil.unitHeight * 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 10),
        Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil.unitHeight * 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeGrid(stats) {
    final List<Color> gridColors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.red[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
      Colors.grey[400]!,
    ];

    final Map<String, IconData> userTypeIcons = {
      'TSM': Icons.leaderboard,
      'ASM': Icons.supervisor_account,
      'SALES_EXECUTIVE': Icons.shopping_cart,
      'SUPER_DISTRIBUTOR': Icons.local_shipping,
      'DISTRIBUTOR': Icons.store_mall_directory,
      'NATIONAL_DISTRIBUTOR': Icons.apartment,
      'MINI_DISTRIBUTOR': Icons.delivery_dining,
      'RETAILER': Icons.storefront,
    };

    String _truncateUserType(String text) {
      if (text.length <= 17) return text;
      return '${text.substring(0, 17)}..';
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) crossAxisCount = 3;
        if (constraints.maxWidth > 900) crossAxisCount = 4;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Type Distribution',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  stats.userTypeCount != null && stats.userTypeCount.isNotEmpty
                      ? GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stats.userTypeCount.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: ScreenUtil.unitHeight * 0.99,
                        ),
                        itemBuilder: (context, index) {
                          final userType = stats.userTypeCount[index];
                          final typeKey = userType.type ?? '';
                          final icon =
                              userTypeIcons[typeKey] ?? Icons.person_outline;
                          final color =
                              gridColors.length > index
                                  ? gridColors[index]
                                  : gridColors.last;

                          return GestureDetector(
                            onTap:
                                () => _onUserTypeGridTap(
                                  typeKey,
                                  userType.count ?? 0,
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: color.withOpacity(0.2),
                                ),
                              ),
                              padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: color,
                                    child: Icon(icon, color: Colors.white),
                                  ),
                                 SizedBox(height: ScreenUtil.unitHeight * 20),
                                  Text(
                                    _truncateUserType(typeKey),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${userType.count ?? 0} users',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                      : Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: ScreenUtil.unitHeight * 20),
                            const Text(
                              'No user type data available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _onUserTypeGridTap(String userType, int count) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UserListScreen(filterByType: userType),
    //   ),
    // );

    print('Tapped on $userType with count: $count');
  }

  Widget _buildTableSection(dynamic stats) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Added Users',
            style: TextStyle(
              fontSize: ScreenUtil.unitHeight * 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil.unitHeight * 20,
                        horizontal: ScreenUtil.unitHeight * 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 120,
                            child: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              'Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            child: Text(
                              'User Type',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil.unitHeight * 10),

                    if (stats.lastAddedUsers != null &&
                        stats.lastAddedUsers.isNotEmpty)
                      ...stats.lastAddedUsers.map<Widget>((user) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                child: Text(
                                  user.name ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.grey[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Text(
                                  user.email ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Text(
                                  user.phone ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.userType ?? '',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    else
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            'No users data available',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
