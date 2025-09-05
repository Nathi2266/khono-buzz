import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userEmail;

  bool get isAuthenticated => _isAuthenticated;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = true;
    _userEmail = email;
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('userEmail', email);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = false;
    _userEmail = null;
    await prefs.remove('isAuthenticated');
    await prefs.remove('userEmail');
    notifyListeners();
  }
}

