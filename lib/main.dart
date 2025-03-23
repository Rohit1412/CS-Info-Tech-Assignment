import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray_app/providers/user_provider.dart';
import 'package:dealsdray_app/screens/splash_screen.dart';
import 'package:dealsdray_app/utils/theme.dart';
import 'package:dealsdray_app/services/api_service.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize API service and device info
  final apiService = ApiService();
  try {
    await apiService.sendDeviceInfo();
  } catch (e) {
    debugPrint('Error initializing device info: $e');
    // Continue with app startup even if device registration fails
    // The app will retry registration when needed
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DealsDray',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: const SplashScreen(),
    );
  }
}
