import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF3F51B5);        // Indigo
  static const Color primaryDark = Color(0xFF303F9F);    // Dark Indigo
  static const Color primaryLight = Color(0xFFC5CAE9);   // Light Indigo
  static const Color accent = Color(0xFFFF4081);         // Pink accent
  
  // UI colors
  static const Color background = Colors.white;
  static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for cards
  static const Color text = Color(0xFF212121);           // Near black for text
  static const Color textSecondary = Color(0xFF757575);  // Medium grey for secondary text
  static const Color textGrey = Color(0xFF9E9E9E);       // Light grey for hint text
  static const Color borderGrey = Color(0xFFE0E0E0);     // Very light grey for borders
  
  // Status colors
  static const Color error = Color(0xFFF44336);          // Red
  static const Color success = Color(0xFF4CAF50);        // Green
  static const Color warning = Color(0xFFFFEB3B);        // Yellow
  static const Color info = Color(0xFF2196F3);           // Blue
  
  // Splash screen gradient colors
  static const Color gradientStart = Color(0xFF3F51B5);  // Indigo
  static const Color gradientEnd = Color(0xFF9C27B0);    // Purple
}

class AppStyles {
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
    letterSpacing: -0.5,
  );

  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: -0.3,
  );

  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
    height: 1.4,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}

class AppDimensions {
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double paddingXXLarge = 48.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  
  static const double buttonHeight = 52.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeLarge = 32.0;
  
  static const double elevation = 2.0;
  static const double elevationLarge = 8.0;
}

class AppAssets {
  // Logo and branding
  static const String logo = 'assets/images/logo.png';
  static const String logoWhite = 'assets/images/logo_white.png';
  static const String splashBackground = 'assets/images/splash_background.png';
  
  // Icons
  static const String iconHome = 'assets/icons/home.svg';
  static const String iconProfile = 'assets/icons/profile.svg';
  static const String iconOrders = 'assets/icons/orders.svg';
  static const String iconCart = 'assets/icons/cart.svg';
  static const String iconSearch = 'assets/icons/search.svg';
  
  // Illustrations
  static const String illustrationVerification = 'assets/images/verification.png';
  static const String illustrationLogin = 'assets/images/login.png';
  static const String illustrationRegister = 'assets/images/register.png';
  static const String illustrationSuccess = 'assets/images/success.png';
}

class ApiEndpoints {
  static const String baseUrl = 'http://devapiv4.dealsdray.com/api/v2';
  static const String deviceAdd = '/user/device/add';
  static const String sendOtp = '/user/otp';
  static const String verifyOtp = '/user/otp/verification';
  static const String register = '/user/email/referral';
  static const String products = '/user/home/withoutPrice';
}

// Animation constants
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
} 