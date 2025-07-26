import 'package:e_warranty/provider/all_user_provider.dart';
import 'package:e_warranty/provider/dashboard_provider.dart';
import 'package:e_warranty/provider/get_single_user_provider.dart';
import 'package:e_warranty/provider/wallet_provider.dart';
import 'package:e_warranty/provider/login_provider.dart';
import 'package:e_warranty/provider/profile_provider.dart';
import 'package:e_warranty/screens/splashscreen.dart';
import 'package:e_warranty/utils/pixelutil.dart';
import 'package:e_warranty/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    ScreenUtil.initialize(context);
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => KeyHistoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => KeyTransferProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => SingleUserProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Warranty App',
        home: const SplashScreen(),
      ),
    );
  }
}