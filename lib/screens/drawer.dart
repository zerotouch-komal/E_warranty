import 'package:e_warranty/screens/Register.dart';
import 'package:e_warranty/screens/dashboard.dart';
import 'package:e_warranty/screens/wallet_history.dart';
import 'package:e_warranty/screens/profile.dart';
import 'package:e_warranty/screens/all_user.dart';
import 'package:e_warranty/screens/warranty.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = 2; 

  final List<Widget> _pages = [
    UserListScreen(),
    RegisterScreen(), 
    DashboardScreen(),
    WarrantyPlan(),
    WalletHistory(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 2,
      onPopInvoked: (didPop) {
        if (!didPop && _selectedIndex != 2) {
          setState(() {
            _selectedIndex = 2;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: ScreenUtil.unitHeight * 100,
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: const Color(0xFF2563EB),
                unselectedItemColor: const Color(0xFF6B7280),
                selectedFontSize: 10,
                unselectedFontSize: 9,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                items: [
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.people_outline_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.people_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.person_add_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Add Users',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.dashboard_outlined,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.dashboard_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.verified_user_outlined,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.verified_user,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Warranty',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet_outlined,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Wallet',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    activeIcon: Padding(
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil.unitHeight * 4,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: ScreenUtil.unitHeight * 24,
                      ),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}