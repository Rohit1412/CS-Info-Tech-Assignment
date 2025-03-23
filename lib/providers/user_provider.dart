import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const _keyMobileNumber = 'mobile_number';
  static const _keyIsLoggedIn = 'is_logged_in';
  static const _keyUserId = 'user_id';
  static const _keyUserName = 'user_name';

  String? _mobileNumber;
  String? _userId;
  String? _userName;
  bool _isLoggedIn = false;

  String? get mobileNumber => _mobileNumber;
  String? get userId => _userId;
  String? get userName => _userName;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _mobileNumber = prefs.getString(_keyMobileNumber);
    _userId = prefs.getString(_keyUserId);
    _userName = prefs.getString(_keyUserName);
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    notifyListeners();
  }

  Future<void> setMobileNumber(String mobileNumber) async {
    _mobileNumber = mobileNumber;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMobileNumber, mobileNumber);
    notifyListeners();
  }

  Future<void> setUserData({
    required String userId,
    required String userName,
  }) async {
    _userId = userId;
    _userName = userName;
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, userName);
    await prefs.setBool(_keyIsLoggedIn, true);
    notifyListeners();
  }

  Future<void> logout() async {
    _mobileNumber = null;
    _userId = null;
    _userName = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyMobileNumber);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyIsLoggedIn);
    notifyListeners();
  }
} 