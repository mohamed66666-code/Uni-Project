import 'package:flutter/material.dart';

class AppColors {
  // Primary Teal & Cyan Palette
  static const Color primary = Color(0xFF0F766E); // Teal 700
  static const Color primaryDark = Color(0xFF134E4A); // Teal 900
  static const Color primaryDeep = Color(0xFF042F2E); // Teal 950
  static const Color primaryLight = Color(0xFF14B8A6); // Teal 500

  // Cyan Accents
  static const Color accent = Color(0xFF0891B2); // Cyan 600
  static const Color cyan = Color(0xFF06B6D4); // Cyan 500
  static const Color cyanLight = Color(0xFF22D3EE); // Cyan 400
  static const Color cyanDark = Color(0xFF0E7490); // Cyan 700

  // Soft Tint Backgrounds & Borders
  static const Color tealTint = Color(0xFFF0FDFA); // Teal 50
  static const Color cyanTint = Color(0xFFECFEFF); // Cyan 50
  static const Color tealBorder = Color(0xFFCCFBF1); // Teal 100
  static const Color cyanBorder = Color(0xFFA5F3FC); // Cyan 200

  // Dark Theme Colors
  static const Color darkScaffold = Color(0xFF071B20);
  static const Color darkCard = Color(0xFF0F2B32);
  static const Color darkBorder = Color(0xFF1B4752);

  // Common Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF0891B2)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF0F766E), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient drawerHeaderGradient = LinearGradient(
    colors: [Color(0xFF042F2E), Color(0xFF0F766E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
