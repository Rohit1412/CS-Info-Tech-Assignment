import 'package:flutter/material.dart';
import 'package:dealsdray_app/utils/constants.dart';
import 'package:dealsdray_app/screens/home_screen.dart';
import 'package:dealsdray_app/services/api_service.dart';
import 'package:dealsdray_app/utils/ui_components.dart';

class RegistrationScreen extends StatefulWidget {
  final String mobileNumber;

  const RegistrationScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  
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
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ApiService().register(
        email: _emailController.text,
        password: _passwordController.text,
        referralCode: _referralController.text.isEmpty ? null : _referralController.text,
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration successful!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
        );
        
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        colors: [
          Colors.white,
          AppColors.primaryLight.withOpacity(0.2),
        ],
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.text),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Illustration
                              Center(
                                child: Image.asset(
                                  AppAssets.illustrationRegister,
                                  height: 180,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback icon if image is not available
                                    return Icon(
                                      Icons.app_registration_rounded,
                                      size: 100,
                                      color: AppColors.primary.withOpacity(0.7),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingLarge),
                              
                              // Title and subtitle
                              Text(
                                'Complete Your Profile',
                                style: AppStyles.heading2,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppDimensions.paddingSmall),
                              Text(
                                'Create your account to access exclusive deals',
                                style: AppStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppDimensions.paddingLarge),
                              
                              // Registration form
                              AppCard(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Mobile number display
                                      Container(
                                        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBackground,
                                          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                                          border: Border.all(color: AppColors.borderGrey),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.phone_android_rounded,
                                              size: AppDimensions.iconSizeSmall,
                                              color: AppColors.primary,
                                            ),
                                            const SizedBox(width: AppDimensions.paddingSmall),
                                            Text(
                                              '+91 ${widget.mobileNumber}',
                                              style: AppStyles.body.copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: AppDimensions.paddingSmall,
                                                vertical: AppDimensions.paddingXSmall,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.success.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(AppDimensions.borderRadiusSmall),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: AppColors.success,
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Verified',
                                                    style: AppStyles.caption.copyWith(
                                                      color: AppColors.success,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: AppDimensions.paddingMedium),
                                      
                                      // Email field
                                      AppTextFormField(
                                        controller: _emailController,
                                        labelText: 'Email Address',
                                        hintText: 'Enter your email',
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: const Icon(Icons.email_outlined),
                                        validator: _validateEmail,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: AppDimensions.paddingMedium),
                                      
                                      // Password field
                                      AppTextFormField(
                                        controller: _passwordController,
                                        labelText: 'Password',
                                        hintText: 'Create a password',
                                        obscureText: _obscurePassword,
                                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                            color: AppColors.textGrey,
                                          ),
                                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                        ),
                                        validator: _validatePassword,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: AppDimensions.paddingMedium),
                                      
                                      // Referral code field
                                      AppTextFormField(
                                        controller: _referralController,
                                        labelText: 'Referral Code (Optional)',
                                        hintText: 'Enter referral code if you have one',
                                        prefixIcon: const Icon(Icons.card_giftcard_outlined),
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(height: AppDimensions.paddingLarge),
                                      
                                      // Register button
                                      AppButton(
                                        label: 'Create Account',
                                        onPressed: _register,
                                        isLoading: _isLoading,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Terms and conditions
                              const SizedBox(height: AppDimensions.paddingLarge),
                              Text(
                                'By creating an account, you agree to our Terms of Service and Privacy Policy',
                                style: AppStyles.caption.copyWith(
                                  color: AppColors.textGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 