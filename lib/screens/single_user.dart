import 'package:e_warranty/provider/all_user_provider.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<UserProvider>().fetchUserDetails(widget.userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "User Details",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          provider.isDetailsLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Loading user details...",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              )
              : provider.userDetails == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "No user data found",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "The requested user information is not available",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(provider),
                    SizedBox(height: ScreenUtil.unitHeight * 20),

                    _buildSection(
                      title: "Personal Information",
                      icon: Icons.person_outline,
                      children: [
                        _buildInfoRow(
                          "Name",
                          provider.userDetails!.name,
                          Icons.badge_outlined,
                        ),
                        _buildInfoRow(
                          "Email",
                          provider.userDetails!.email,
                          Icons.email_outlined,
                        ),
                        _buildInfoRow(
                          "Phone",
                          provider.userDetails!.phone,
                          Icons.phone_outlined,
                        ),
                        _buildInfoRow(
                          "User Type",
                          provider.userDetails!.userType,
                          Icons.verified_user_outlined,
                        ),
                        _buildStatusRow(
                          "Status",
                          provider.userDetails!.isActive,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.unitHeight * 20),

                    _buildSection(
                      title: "Address",
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildInfoRow(
                          "Street",
                          provider.userDetails!.address.street,
                          Icons.home_outlined,
                        ),
                        _buildInfoRow(
                          "City",
                          provider.userDetails!.address.city,
                          Icons.location_city_outlined,
                        ),
                        _buildInfoRow(
                          "State",
                          provider.userDetails!.address.state,
                          Icons.map_outlined,
                        ),
                        _buildInfoRow(
                          "Country",
                          provider.userDetails!.address.country,
                          Icons.public_outlined,
                        ),
                        _buildInfoRow(
                          "Zip Code",
                          provider.userDetails!.address.zipCode,
                          Icons.markunread_mailbox_outlined,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.unitHeight * 20),

                    _buildSection(
                      title: "Key Allocation",
                      icon: Icons.vpn_key_outlined,
                      children: [_buildKeyAllocationCard(provider)],
                    ),
                    SizedBox(height: ScreenUtil.unitHeight * 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileCard(UserProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: ScreenUtil.unitHeight * 100,
            height: ScreenUtil.unitHeight * 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                provider.userDetails!.name.isNotEmpty
                    ? provider.userDetails!.name[0].toUpperCase()
                    : '',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: ScreenUtil.unitHeight * 10),
          Text(
            provider.userDetails!.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: ScreenUtil.unitHeight * 15),
          Text(
            provider.userDetails!.email,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil.unitHeight * 20, vertical: 6),
            decoration: BoxDecoration(
              color:
                  provider.userDetails!.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              provider.userDetails!.isActive ? "Active" : "Inactive",
              style: TextStyle(
                color:
                    provider.userDetails!.isActive
                        ? Colors.green[700]
                        : Colors.red[700],
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Theme.of(context).primaryColor),
              SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          SizedBox(width: ScreenUtil.unitHeight * 20),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 20,
            color: isActive ? Colors.green[500] : Colors.red[500],
          ),
          SizedBox(width: ScreenUtil.unitHeight * 20),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? "Active" : "Inactive",
                style: TextStyle(
                  color: isActive ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyAllocationCard(UserProvider provider) {
    final usedKeys = provider.userDetails!.keyAllocation.usedKeys;
    final remainingKeys = provider.userDetails!.keyAllocation.remainingKeys;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildKeyStatCard(
              title: "Remaining Keys",
              value: remainingKeys.toString(),
              icon: Icons.vpn_key_outlined,
              color: Colors.blue,
            ),
            _buildKeyStatCard(
              title: "Used Keys",
              value: usedKeys.toString(),
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
