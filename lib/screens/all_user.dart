import 'package:e_warranty/provider/all_user_provider.dart';
import 'package:e_warranty/provider/wallet_provider.dart';
import 'package:e_warranty/screens/single_user.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  final String? userType;

  const UserListScreen({super.key, this.userType});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _userTypes = [
    'ALL',
    'TSM',
    'ASM',
    'SALES_EXECUTIVE',
    'SUPER_DISTRIBUTOR',
    'DISTRIBUTOR',
    'NATIONAL_DISTRIBUTOR',
    'MINI_DISTRIBUTOR',
    'RETAILER',
  ];

  String _selectedUserType = 'ALL';

  @override
  void initState() {
    super.initState();
    if (widget.userType != null) {
      _selectedUserType = widget.userType!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchAllUsers(userType: _selectedUserType);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final userProvider = context.read<UserProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.6 &&
        !userProvider.isFetchingMore) {
      userProvider.fetchMoreUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final users = userProvider.users;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _buildBody(users, userProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(List<dynamic> users, UserProvider userProvider) {
    if (userProvider.isLoading) {
      return _buildLoadingState();
    }
    
    if (users.isEmpty) {
      return _buildEmptyState();
    }
    
    return _buildUserList(users, userProvider);
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
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
  );

  Widget _buildFilterSection() => Container(
    padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.filter_list, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              "Filter by User Type",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil.unitHeight * 20),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.unitHeight * 20,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUserType,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              items: _userTypes.map((String userType) {
                return DropdownMenuItem<String>(
                  value: userType,
                  child: Text(
                    userType == 'ALL'
                        ? 'All Users'
                        : userType.replaceAll('_', ' '),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: userType == _selectedUserType
                          ? Colors.blue
                          : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _selectedUserType) {
                  setState(() {
                    _selectedUserType = newValue;
                  });
                  _applyFilter();
                }
              },
            ),
          ),
        ),
      ],
    ),
  );

  void _applyFilter() {
    context.read<UserProvider>().fetchAllUsers(userType: _selectedUserType);
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
        SizedBox(height: ScreenUtil.unitHeight * 20),
        Text(
          'No users found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 10),
        Text(
          _selectedUserType == 'ALL'
              ? 'No users available at the moment'
              : 'No ${_selectedUserType.replaceAll('_', ' ')} users found',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    ),
  );

  Widget _buildLoadingState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 20),
        Text(
          _selectedUserType == 'ALL' 
              ? 'Loading users...' 
              : 'Loading ${_selectedUserType.replaceAll('_', ' ')} users...',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );

  Widget _buildUserList(List<dynamic> users, UserProvider userProvider) =>
      RefreshIndicator(
        onRefresh: () => userProvider.fetchAllUsers(userType: _selectedUserType),
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.all(ScreenUtil.unitHeight * 20),
          itemCount: users.length + (userProvider.isFetchingMore ? 1 : 0),
          itemBuilder: (context, index) =>
              index < users.length
                  ? _buildUserCard(
                      users[index],
                      userProvider.getCreatorLabel(users[index]),
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    ),
        ),
      );

  Widget _buildUserCard(dynamic user, String creator) => GestureDetector(
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(userId: user.userId),
      ),
    ),
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
            _buildUserHeader(user),
            SizedBox(height: ScreenUtil.unitHeight * 20),
            _buildCreatorInfo(creator),
            SizedBox(height: ScreenUtil.unitHeight * 20),
            _buildWalletSection(user),
            SizedBox(height: ScreenUtil.unitHeight * 20),
            _buildTransferButton(user.userId),
          ],
        ),
      ),
    ),
  );

  Widget _buildUserHeader(dynamic user) => Row(
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
          style: const TextStyle(
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
                style: const TextStyle(
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
  );

  Widget _buildCreatorInfo(String creator) => Row(
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
  );

  Widget _buildWalletSection(dynamic user) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Wallet Balance",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
      SizedBox(height: ScreenUtil.unitHeight * 20),
      _buildKeyStatCard(
        title: "Available Amount",
        value: user.walletBalance.remainingAmount.toStringAsFixed(2),
        icon: Icons.account_balance_wallet_outlined,
        color: Colors.teal,
      ),
    ],
  );

  Widget _buildTransferButton(String userId) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () => _handleTransferKey(context, userId),
      icon: const Icon(Icons.swap_horiz, size: 18),
      label: const Text(
        "Transfer Amount",
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 0,
        side: BorderSide(color: Colors.blueAccent.withOpacity(0.3), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.unitHeight * 20,
          vertical: ScreenUtil.unitHeight * 20,
        ),
      ),
    ),
  );

  void _handleTransferKey(BuildContext context, String userId) async {
    final controller = TextEditingController();
    final keyProvider = Provider.of<KeyTransferProvider>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
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
              _buildDialogHeader(),
              SizedBox(height: ScreenUtil.unitHeight * 20),
              _buildAmountField(controller),
              SizedBox(height: ScreenUtil.unitHeight * 20),
              _buildDialogActions(controller, keyProvider, userId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialogHeader() => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.wallet, color: Colors.blue, size: 24),
      ),
      SizedBox(width: ScreenUtil.unitHeight * 20),
      const Expanded(
        child: Text(
          "Transfer Amount",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    ],
  );

  Widget _buildAmountField(TextEditingController controller) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Number of Amount",
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter number of amount to transfer",
          hintStyle: TextStyle(color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          border: _buildInputBorder(Colors.blue.withOpacity(0.3)),
          enabledBorder: _buildInputBorder(Colors.blue.withOpacity(0.3)),
          focusedBorder: _buildInputBorder(Colors.blue, 2),
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
    ],
  );

  OutlineInputBorder _buildInputBorder(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  Widget _buildDialogActions(
    TextEditingController controller,
    KeyTransferProvider keyProvider,
    String userId,
  ) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.black54,
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil.unitHeight * 20,
            vertical: ScreenUtil.unitHeight * 20,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          "Cancel",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(width: ScreenUtil.unitHeight * 20),
      FilledButton(
        onPressed: () => _processTransfer(controller, keyProvider, userId),
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
  );

  void _processTransfer(
    TextEditingController controller,
    KeyTransferProvider keyProvider,
    String userId,
  ) async {
    final count = int.tryParse(controller.text);
    if (count == null || count <= 0) {
      _showSnackBar(
        "Please enter a valid number",
        Colors.orange.shade600,
        Icons.warning_amber_outlined,
      );
      return;
    }

    _showLoadingDialog();
    final success = await keyProvider.transferKeys(userId, count);
    Navigator.of(context).pop();

    if (mounted) {
      if (success) {
        _showSnackBar(
          "Keys transferred successfully",
          Colors.green.shade600,
          Icons.check_circle_outline,
        );
        context.read<UserProvider>().fetchAllUsers(userType: _selectedUserType);
        Navigator.of(context).pop();
      } else {
        _showSnackBar(
          keyProvider.error ?? "Failed to transfer amount",
          Colors.red.shade600,
          Icons.error_outline,
        );
      }
    }
  }

  void _showLoadingDialog() => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  void _showSnackBar(String message, Color backgroundColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildKeyStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) => Container(
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