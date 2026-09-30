import 'package:flutter/material.dart';

const kTeal = Color(0xFF10BDB8);
const kBg = Color(0xFFF6FBFB);
const kInk = Color(0xFF0F2A2A);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: kTeal, primary: kTeal),
      scaffoldBackgroundColor: kBg,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: kInk,
          elevation: 0,
          scrolledUnderElevation: 1),
      navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Colors.white, indicatorColor: Color(0x3310BDB8)),
    );
