import 'package:e_warranty/screens/dashboard.dart';
import 'package:e_warranty/screens/key_history.dart';
import 'package:e_warranty/screens/profile.dart';
import 'package:e_warranty/screens/retailer.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final String? currentRoute;

  const MyDrawer({
    super.key,
    this.currentRoute,
  });

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String userName = "User";
  String userEmail = "user@example.com";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final name = await SharedPreferenceHelper.instance.getString('name');
      final email = await SharedPreferenceHelper.instance.getString('email');
      
      setState(() {
        userName = name ?? "User";
        userEmail = email ?? "user@example.com";
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget page,
    required String route,
  }) {
    bool isSelected = widget.currentRoute == route;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.blue : Colors.grey[800],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {
          if (!isSelected) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: 260,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1976D2),
                  Color(0xFF1565C0),
                  Color(0xFF0D47A1),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            _getInitials(userName),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 20),
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  page: DashboardScreen(),
                  route: '/dashboard',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.person_add_rounded,
                  title: 'Add User',
                  page: DashboardScreen(),
                  route: '/add_user',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.people_rounded,
                  title: 'Users',
                  page: RetailerScreen(),
                  route: '/users',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.vpn_key_rounded,
                  title: 'Key History',
                  page: KeyHistoryScreen(),
                  route: '/key_history',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.receipt_long_rounded,
                  title: 'Transactions',
                  page: DashboardScreen(),
                  route: '/transactions',
                ),
                _buildDrawerItem(
                  context: context,
                  icon: Icons.account_circle_outlined,
                  title: 'My Profile',
                  page: ProfileScreen(), 
                  route: '/profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}