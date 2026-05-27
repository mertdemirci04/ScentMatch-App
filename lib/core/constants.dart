import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2C3E50);
  static const Color secondary = Color(0xFFD4AF37);
  static const Color background = Color(0xFFF8F9FA);
  static const Color textDark = Color(0xFF212529);
  static const Color textLight = Color(0xFF6C757D);
  static const Color bg = Color(0xFF0a0806);
  static const Color gold = Color(0xFFc9a96e);
  static const Color goldLight = Color(0xFFe8d5a3);
  static const Color goldDark = Color(0xFF8b6914);
  static const Color text = Color(0xFFf0ebe0);
  
  static final Color textMuted = const Color(0xFFf0ebe0).withOpacity(0.45);
  static final Color surface = Colors.white.withOpacity(0.03);
  static final Color surface2 = const Color(0xFFc9a96e).withOpacity(0.07);
  static final Color border = const Color(0xFFc9a96e).withOpacity(0.18);
}

class AppConstants {
  static const String appName = 'ScentMatch';
  static const String dbName = 'scent_match.db';
}