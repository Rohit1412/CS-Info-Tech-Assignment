import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF2196F3);
const Color secondaryColor = Color(0xFF03A9F4);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color textColor = Color(0xFF212121);
const Color greyColor = Color(0xFF9E9E9E);

// API Constants
const String baseUrl = 'https://api.dealsdray.com';
const String apiVersion = 'v1';

// Storage Keys
const String tokenKey = 'token';
const String userIdKey = 'userId';
const String mobileNumberKey = 'mobileNumber';
const String userNameKey = 'userName';

// Validation Constants
const int otpLength = 6;
const int mobileNumberLength = 10;
const int minPasswordLength = 6;

// Animation Duration
const Duration splashDuration = Duration(seconds: 2);
const Duration animationDuration = Duration(milliseconds: 300); 