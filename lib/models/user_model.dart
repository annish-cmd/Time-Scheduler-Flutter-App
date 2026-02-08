import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  String _name = 'Patrick Bateman';
  String _email = 'patrick.bateman@example.com';
  String? _imagePath;
  bool _isDarkMode = false;

  // Getters
  String get name => _name;
  String get email => _email;
  String? get imagePath => _imagePath;
  bool get isDarkMode => _isDarkMode;

  // Check if user has a profile image
  bool get hasProfileImage => _imagePath != null;

  // Returns either the File or null if no image is set
  File? get profileImage => _imagePath != null ? File(_imagePath!) : null;

  // Initialize user from shared preferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? 'Patrick Bateman';
    _email = prefs.getString('user_email') ?? 'patrick.bateman@example.com';
    _imagePath = prefs.getString('user_image_path');
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;
    notifyListeners();
  }

  // Set user name
  Future<void> setName(String name) async {
    if (name.isNotEmpty) {
      _name = name;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      notifyListeners();
    }
  }

  // Set user email
  Future<void> setEmail(String email) async {
    if (email.isNotEmpty) {
      _email = email;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      notifyListeners();
    }
  }

  // Set profile image path
  Future<void> setImagePath(String path) async {
    _imagePath = path;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image_path', path);
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', _isDarkMode);
    notifyListeners();
  }
}
