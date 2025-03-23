import 'dart:async';

import 'package:dealsdray_app/screens/home_screen.dart';
import 'package:dealsdray_app/screens/registration_screen.dart';
import 'package:dealsdray_app/services/api_service.dart';
import 'package:dealsdray_app/utils/constants.dart';
import 'package:dealsdray_app/utils/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationScreen({
    super.key,
    required this.mobileNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimer = 30;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

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

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter complete OTP'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final isNewUser = await ApiService().verifyOtp(_otpController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OTP verified successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => isNewUser
                ? RegistrationScreen(mobileNumber: widget.mobileNumber)
                : const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to verify OTP: ${e.toString()}'),
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

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;

    setState(() => _isResending = true);

    try {
      await ApiService().sendOtp(widget.mobileNumber);

      if (mounted) {
        setState(() {
          _resendTimer = 30;
          _startResendTimer();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OTP sent successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${e.toString()}'),
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
        setState(() => _isResending = false);
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
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
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: AppColors.text),
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
                          padding:
                              const EdgeInsets.all(AppDimensions.paddingLarge),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Illustration
                                Center(
                                  child: Image.asset(
                                    AppAssets.illustrationVerification,
                                    height: 180,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback icon if image is not available
                                      return Icon(
                                        Icons.message_rounded,
                                        size: 120,
                                        color:
                                            AppColors.primary.withOpacity(0.7),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                    height: AppDimensions.paddingLarge),

                                // Title and instructions
                                Text(
                                  'Verification Code',
                                  style: AppStyles.heading2,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                    height: AppDimensions.paddingSmall),
                                Text(
                                  'We have sent the verification code to',
                                  style: AppStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                    height: AppDimensions.paddingSmall),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.phone_android_rounded,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(
                                        width: AppDimensions.paddingXSmall),
                                    Text(
                                      '+91 ${widget.mobileNumber}',
                                      style: AppStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                    height: AppDimensions.paddingXLarge),

                                // OTP input
                                AppCard(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(
                                      AppDimensions.borderRadiusLarge),
                                  padding: const EdgeInsets.all(
                                      AppDimensions.paddingLarge),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Enter 4-Digit Code',
                                        style: AppStyles.bodySmall.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: AppDimensions.paddingMedium),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              AppDimensions.paddingSmall,
                                        ),
                                        child: PinCodeTextField(
                                          appContext: context,
                                          length: 4,
                                          controller: _otpController,
                                          keyboardType: TextInputType.number,
                                          animationType: AnimationType.fade,
                                          pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderRadius: BorderRadius.circular(
                                                AppDimensions
                                                    .borderRadiusSmall),
                                            fieldHeight: 55,
                                            fieldWidth: 55,
                                            activeFillColor:
                                                AppColors.cardBackground,
                                            inactiveFillColor:
                                                AppColors.cardBackground,
                                            selectedFillColor:
                                                AppColors.cardBackground,
                                            activeColor: AppColors.primary,
                                            inactiveColor: AppColors.borderGrey,
                                            selectedColor: AppColors.primary,
                                          ),
                                          animationDuration: AppAnimations.fast,
                                          enableActiveFill: true,
                                          onCompleted: (_) => _verifyOtp(),
                                          beforeTextPaste: (text) =>
                                              text?.length == 4,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: AppDimensions.paddingLarge),

                                      // Verify button
                                      AppButton(
                                        label: 'Verify',
                                        onPressed: _verifyOtp,
                                        isLoading: _isLoading,
                                      ),

                                      const SizedBox(
                                          height: AppDimensions.paddingLarge),

                                      // Resend button
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Didn't receive the code? ",
                                            style: AppStyles.bodySmall.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: _resendOtp,
                                            child: _isResending
                                                ? const SizedBox(
                                                    height: 16,
                                                    width: 16,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              AppColors
                                                                  .primary),
                                                    ),
                                                  )
                                                : Text(
                                                    _resendTimer > 0
                                                        ? 'Resend in $_resendTimer s'
                                                        : 'Resend',
                                                    style: AppStyles.bodySmall
                                                        .copyWith(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    height: AppDimensions.paddingLarge),

                                // Security note
                                Container(
                                  padding: const EdgeInsets.all(
                                      AppDimensions.paddingMedium),
                                  decoration: BoxDecoration(
                                    color: AppColors.info.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.borderRadius),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        color: AppColors.info,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                          width: AppDimensions.paddingSmall),
                                      Expanded(
                                        child: Text(
                                          'Never share your OTP with anyone. Our team will never ask for your OTP.',
                                          style: AppStyles.caption.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
