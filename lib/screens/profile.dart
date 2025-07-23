import 'package:e_warranty/provider/login_provider.dart';
import 'package:e_warranty/screens/change_password.dart';
import 'package:e_warranty/screens/login.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).loadUserProfile();
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading || provider.user == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
              ),
            );
          }

          final user = provider.user!;
          final companyAddress = user.company.address;
          final userKeys = user.keyAllocation;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1976D2), Color(0xFF1565C0)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 20, 24, 40),
                    child: Column(
                      children: [
                        Container(
                          width: ScreenUtil.unitHeight * 100,
                          height: ScreenUtil.unitHeight * 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user.company.name.isNotEmpty
                                  ? user.company.name[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: ScreenUtil.unitHeight * 40,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil.unitHeight * 20),

                        Text(
                          user.company.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        title: 'Contact Information',
                        icon: Icons.contact_phone_rounded,
                        children: [
                          _buildInfoRow(Icons.person, 'Name', user.name),
                          SizedBox(height: ScreenUtil.unitHeight * 20),
                          _buildInfoRow(
                            Icons.phone_rounded,
                            'Phone',
                            user.phone,
                          ),
                          SizedBox(height: ScreenUtil.unitHeight * 20),
                          _buildInfoRow(
                            Icons.email_rounded,
                            'Email',
                            user.email,
                          ),
                        ],
                      ),

                      SizedBox(height: ScreenUtil.unitHeight * 20),

                      _buildInfoCard(
                        title: 'Address',
                        icon: Icons.location_on_rounded,
                        children: [
                          _buildInfoRow(
                            Icons.home_rounded,
                            'Location',
                            '${companyAddress.street}, ${companyAddress.city}',
                          ),
                          SizedBox(height: ScreenUtil.unitHeight * 20),
                          _buildInfoRow(
                            Icons.map_rounded,
                            'Region',
                            '${companyAddress.state}, ${companyAddress.country}',
                          ),
                          SizedBox(height: ScreenUtil.unitHeight * 20),
                          _buildInfoRow(
                            Icons.local_post_office_rounded,
                            'Zip Code',
                            companyAddress.zipCode,
                          ),
                        ],
                      ),

                      SizedBox(height: ScreenUtil.unitHeight * 20),

                      _buildKeyAllocationCard(userKeys),

                      SizedBox(height: ScreenUtil.unitHeight * 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _navigateToChangePassword(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil.unitHeight * 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: ScreenUtil.unitHeight * 20),
                              Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: ScreenUtil.unitHeight * 20),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showLogoutDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildInfoCard({
  required String title,
  required IconData icon,
  required List<Widget> children,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          ...children,
        ],
      ),
    ),
  );
}

Widget _buildInfoRow(IconData icon, String label, String value) {
  return Row(
    children: [
      Icon(icon, size: 18, color: Colors.grey.shade600),
      SizedBox(width: ScreenUtil.unitHeight * 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: ScreenUtil.unitHeight * 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildKeyAllocationCard(dynamic userKeys) {
  final totalKeys = userKeys.remainingKeys + userKeys.usedKeys;
  final remainingPercentage =
      totalKeys > 0 ? (userKeys.remainingKeys / totalKeys) : 0.0;

  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1976D2).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1976D2).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.vpn_key_rounded,
                    color: Color(0xFF1976D2),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                const Text(
                  'Keys',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil.unitHeight * 20),

            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: remainingPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            SizedBox(height: ScreenUtil.unitHeight * 20),

            Row(
              children: [
                SizedBox(width: ScreenUtil.unitHeight * 20),
                Expanded(
                  child: _buildKeyStatItem(
                    'Keys',
                    userKeys.remainingKeys.toString(),
                    Icons.check_circle_rounded,
                    const Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(width: ScreenUtil.unitHeight * 20),
                Expanded(
                  child: _buildKeyStatItem(
                    'Used',
                    userKeys.usedKeys.toString(),
                    Icons.history_rounded,
                    const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildKeyStatItem(
  String label,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: ScreenUtil.unitHeight * 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

void _navigateToChangePassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).logoutWithoutNavigation();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );

              ScaffoldMessenger.of(context).showSnackBar(
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
