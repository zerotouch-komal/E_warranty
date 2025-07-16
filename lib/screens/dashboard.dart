import 'package:e_warranty/provider/dashboard_provider.dart';
import 'package:e_warranty/screens/drawer.dart';
import 'package:e_warranty/screens/key_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
      ),
      drawer: MyDrawer(currentRoute: '/dashboard'),
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
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
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
                fontSize: 24,
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
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
          padding: EdgeInsets.all(24),
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
                height: 60,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
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
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeGrid(dynamic stats) {
  final List<Color> gridColors = [
    Colors.blue[400]!,
    Colors.green[400]!,
    Colors.orange[400]!,
    Colors.purple[400]!,
    Colors.red[400]!,
    Colors.teal[400]!,
    Colors.indigo[400]!,
    Colors.pink[400]!,
  ];

  final Map<String, IconData> userTypeIcons = {
    'RETAILER': Icons.store,
    'MINI_DISTRIBUTOR': Icons.local_shipping,
    'ASM': Icons.supervisor_account,
    'SUPER_DISTRIBUTOR': Icons.business,
    'ADMIN': Icons.admin_panel_settings,
    'MANAGER': Icons.manage_accounts,
    'SALES': Icons.point_of_sale,
    'SUPPORT': Icons.support_agent,
  };

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
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Type Distribution',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                stats.userTypeCount != null && stats.userTypeCount.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: stats.userTypeCount.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final userType = stats.userTypeCount[index];
                          final color = gridColors[index % gridColors.length];
                          final icon = userTypeIcons[userType.type] ?? Icons.person;

                          return GestureDetector(
                            onTap: () => _onUserTypeGridTap(userType.type ?? '', userType.count ?? 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: color.withOpacity(0.2)),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: color,
                                    child: Icon(icon, color: Colors.white),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    userType.type ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 6),
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
                        padding: EdgeInsets.symmetric(vertical: 40),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people_outline, size: 50, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              'No user type data available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
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
    // Example: Navigate to a filtered user list page
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
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
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
                    SizedBox(height: 8),
                    
                    if (stats.lastAddedUsers != null && stats.lastAddedUsers.isNotEmpty)
                      ...stats.lastAddedUsers.map<Widget>((user) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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