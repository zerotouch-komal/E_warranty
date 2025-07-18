import 'package:e_warranty/provider/all_user_provider.dart';
import 'package:e_warranty/provider/key_provider.dart';
import 'package:e_warranty/screens/single_user.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<UserProvider>().fetchAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final users = userProvider.users;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "User Management",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.grey[200]),
        ),
      ),
      
      body:
          users.isEmpty
              ? _buildLoadingState()
              : _buildUserList(users, userProvider, theme),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: ScreenUtil.unitHeight * 20),
          Text(
            'Loading users...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(
    List<dynamic> users,
    UserProvider userProvider,
    ThemeData theme,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await userProvider.fetchAllUsers();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final creator = userProvider.getCreatorLabel(user);
          return _buildUserCard(user, creator, theme);
        },
      ),
    );
  }

  Widget _buildUserCard(dynamic user, String creator, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(userId: user.userId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil.unitHeight * 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueAccent.withOpacity(0.1),
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: ScreenUtil.unitHeight * 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.unitHeight * 5,
                            vertical: ScreenUtil.unitHeight * 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user.userType,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              SizedBox(height: ScreenUtil.unitHeight * 20),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    "Created by: ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    creator,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ScreenUtil.unitHeight * 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Key Usage",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKeyStatCard(
                          title: "Remaining Keys",
                          value: user.keyAllocation.remainingKeys.toString(),
                          icon: Icons.vpn_key_outlined,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: ScreenUtil.unitHeight * 20),
                      Expanded(
                        child: _buildKeyStatCard(
                          title: "Used Keys",
                          value: user.keyAllocation.usedKeys.toString(),
                          icon: Icons.check_circle_outline,
                          color: _getUsageColor(
                            user.keyAllocation.usedKeys,
                            user.keyAllocation.totalKeys,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: ScreenUtil.unitHeight * 20),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _handleTransferKey(context, user.userId);
                  },
                  icon: const Icon(
                    Icons.swap_horiz,
                    size: 18,
                  ),
                  label: const Text(
                    "Transfer Key",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    elevation: 0,
                    side: BorderSide(
                      color: Colors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil.unitHeight * 20,
                      vertical: ScreenUtil.unitHeight * 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


void _handleTransferKey(BuildContext context, String userId) async {
  final TextEditingController controller = TextEditingController();
  final keyProvider = Provider.of<KeyTransferProvider>(context, listen: false);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.key_rounded,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: ScreenUtil.unitHeight * 20),
                  const Expanded(
                    child: Text(
                      "Transfer Keys",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil.unitHeight * 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Number of Keys",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter number of keys to transfer",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.blue.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil.unitHeight * 20,
                    vertical: ScreenUtil.unitHeight * 20,
                  ),
                  prefixIcon: Icon(
                    Icons.numbers_rounded,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                ),
              ),

              SizedBox(height: ScreenUtil.unitHeight * 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.unitHeight * 20, vertical: ScreenUtil.unitHeight * 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(width: ScreenUtil.unitHeight * 20),
                  FilledButton(
                    onPressed: () async {
                      final count = int.tryParse(controller.text);
                      if (count != null && count > 0) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        final success = await keyProvider.transferKeys(userId, count,);

                        Navigator.of(context).pop();

                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Row(
                                  children: [
                                    Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                    SizedBox(width: 12),
                                    Text(
                                      "Keys transferred successfully",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.all(ScreenUtil.unitHeight * 20),
                              ),
                            );
                            context.read<UserProvider>().fetchAllUsers();
                            Navigator.of(context).pop(); 
                            
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: Colors.white, size: 20),
                                    SizedBox(width: ScreenUtil.unitHeight * 20),
                                    Expanded(
                                      child: Text(
                                        keyProvider.error ?? "Failed to transfer keys",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.red.shade600,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.warning_amber_outlined, color: Colors.white, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  "Please enter a valid number",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.orange.shade600,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send_rounded, size: 18),
                        SizedBox(width: 8),
                        Text("Transfer", style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
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
          const SizedBox(height: 8),
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

  Color _getUsageColor(int usedKeys, int totalKeys) {
    if (totalKeys == 0) return Colors.grey;

    final percentage = usedKeys / totalKeys;
    if (percentage > 0.8) {
      return Colors.red;
    } else if (percentage > 0.6) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}
