import 'package:e_warranty/provider/customer_provider.dart';
import 'package:e_warranty/screens/customer_detail.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer_model.dart';

class AllCustomer extends StatefulWidget {
  const AllCustomer({Key? key}) : super(key: key);

  @override
  State<AllCustomer> createState() => _AllCustomerState();
}

class _AllCustomerState extends State<AllCustomer> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.6) {
      context.read<CustomerProvider>().loadMoreCustomers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          Consumer<CustomerProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.customers.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }

              if (provider.error != null && provider.customers.isEmpty) {
                return SliverFillRemaining(child: _buildErrorState(provider));
              }

              if (provider.customers.isEmpty) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == provider.customers.length) {
                      return provider.isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    }
                    return CustomerCard(customer: provider.customers[index]);
                  },
                  childCount: provider.customers.length + (provider.isLoadingMore ? 1 : 0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: false,
      snap: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF1A1A1A),
      title: const Text(
        'Customers',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildErrorState(CustomerProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Unable to load customers',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          SizedBox(height: 8),
          Text(
            provider.error!,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: () => provider.refreshCustomers(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No customers found',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;

  const CustomerCard({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerDetailScreen(
              customerId: customer.customerId,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.unitHeight * 18, vertical: ScreenUtil.unitHeight * 8),
        padding: EdgeInsets.all(ScreenUtil.unitHeight * 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),
        child: Row(
          children: [
            _buildAvatar(),
            SizedBox(width: ScreenUtil.unitHeight * 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.customerDetails.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil.unitHeight * 18,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.unitHeight * 6),
                  _buildSubtitle(),
                ],
              ),
            ),
            SizedBox(width: ScreenUtil.unitHeight * 10),
            _buildTrailing(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final initial = customer.customerDetails.name.isNotEmpty
        ? customer.customerDetails.name[0].toUpperCase()
        : 'C';

    return Container(
      width: ScreenUtil.unitHeight * 50,
      height: ScreenUtil.unitHeight * 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil.unitHeight * 20,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          customer.warrantyKey,
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: ScreenUtil.unitHeight * 14,
          ),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 4),
        Text(
          customer.productDetails.modelName,
          style: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: ScreenUtil.unitHeight * 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil.unitHeight * 10, vertical: ScreenUtil.unitHeight * 4),
          decoration: BoxDecoration(
            color: customer.isActive
                ? const Color(0xFFF0FDF4)
                : const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: customer.isActive
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFDC2626),
              width: 0.5,
            ),
          ),
          child: Text(
            customer.isActive ? 'Active' : 'Inactive',
            style: TextStyle(
              color: customer.isActive
                  ? const Color(0xFF16A34A)
                  : const Color(0xFFDC2626),
              fontSize: ScreenUtil.unitHeight * 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: ScreenUtil.unitHeight * 8),
        Text(
          '₹${customer.warrantyDetails.premiumAmount.toStringAsFixed(0)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ScreenUtil.unitHeight * 16,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
