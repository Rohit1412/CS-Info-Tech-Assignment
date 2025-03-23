import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dealsdray_app/utils/constants.dart';
import 'package:dealsdray_app/screens/otp_verification_screen.dart';
import 'package:dealsdray_app/services/api_service.dart';
import 'package:dealsdray_app/utils/ui_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _mobileController = TextEditingController(text: '9011470243'); // Pre-filled for testing
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService().sendOtp(_mobileController.text);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              mobileNumber: _mobileController.text,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;
    
    return Scaffold(
      body: GradientContainer(
        colors: [
          Colors.white,
          AppColors.primaryLight.withOpacity(0.3),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLarge,
                    vertical: AppDimensions.paddingXLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and header
                      Center(
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_bag_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Illustration
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Image.asset(
                            AppAssets.illustrationLogin,
                            height: isMobile ? 200 : 300,
                            errorBuilder: (context, error, stackTrace) {
                              // If image is not available, show a placeholder
                              return Container(
                                height: isMobile ? 200 : 300,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.smartphone_rounded,
                                  size: 100,
                                  color: AppColors.primary.withOpacity(0.7),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Welcome text
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to DealsDray',
                                style: AppStyles.heading2,
                              ),
                              const SizedBox(height: AppDimensions.paddingSmall),
                              Text(
                                'Enter your mobile number to continue',
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      
                      // Mobile number input
                      Transform.translate(
                        offset: Offset(0, _slideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Form(
                            key: _formKey,
                            child: AppCard(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Country code prefix
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppDimensions.paddingMedium,
                                          vertical: AppDimensions.paddingMedium,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                                          border: Border.all(color: AppColors.borderGrey),
                                        ),
                                        child: Row(
                                          children: [
                                            // Indian flag colors
                                            Container(
                                              width: 24,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(2),
                                                border: Border.all(color: AppColors.borderGrey, width: 0.5),
                                              ),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(color: Colors.orange),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(color: Colors.white),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Container(color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '+91',
                                              style: AppStyles.body.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: AppDimensions.paddingMedium),
                                      
                                      // Mobile number field
                                      Expanded(
                                        child: AppTextFormField(
                                          controller: _mobileController,
                                          hintText: 'Mobile Number',
                                          labelText: 'Mobile Number',
                                          keyboardType: TextInputType.number,
                                          prefixIcon: const Icon(Icons.phone_android_rounded),
                                          validator: _validateMobile,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                            LengthLimitingTextInputFormatter(10),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppDimensions.paddingLarge),
                                  
                                  AppButton(
                                    label: 'Send OTP',
                                    icon: Icons.send_rounded,
                                    onPressed: _sendOtp,
                                    isLoading: _isLoading,
                                  ),
                                  
                                  // Test information for demo purposes
                                  const SizedBox(height: AppDimensions.paddingLarge),
                                  Container(
                                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                                    decoration: BoxDecoration(
                                      color: AppColors.info.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                                      border: Border.all(color: AppColors.info.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.info_outline_rounded,
                                              size: 16,
                                              color: AppColors.info,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Testing Info',
                                              style: AppStyles.bodySmall.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.info,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Use OTP: 9879',
                                          style: AppStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 