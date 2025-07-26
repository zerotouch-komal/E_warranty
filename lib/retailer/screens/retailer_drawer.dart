import 'package:e_warranty/retailer/screens/retailer_dashboard.dart';
import 'package:e_warranty/retailer/screens/retailer_history.dart';
import 'package:flutter/material.dart';
import 'retailer_profile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Drawer Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(color: Colors.blue.withOpacity(0.2)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    child: Icon(Icons.store, size: 40, color: Colors.blue[700]),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'E-Warranty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                     onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RetailerDashboard(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.assignment,
                    title: 'Claims',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_balance_wallet,
                    title: 'Transactions',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryData(),
                        ),
                      );
                    },
                  ),
                
                  _buildDrawerItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RetailerProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(
        title,
        style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      hoverColor: Colors.blue.withOpacity(0.1),
    );
  }
}
