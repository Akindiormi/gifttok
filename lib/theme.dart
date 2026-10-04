import 'package:flutter/material.dart';

const kTeal = Color(0xFF10BDB8);
const kBg = Color(0xFF071314);
const kCard = Color(0xFF0E2124);
const kBorder = Color(0xFF1A3A3D);
const kMuted = Color(0xFF8FAFB0);
const kLive = Color(0xFFFF4D6D);

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
          seedColor: kTeal, brightness: Brightness.dark, primary: kTeal),
      scaffoldBackgroundColor: kBg,
      appBarTheme: const AppBarTheme(
          backgroundColor: kBg,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0),
      navigationBarTheme: NavigationBarThemeData(
          backgroundColor: kCard,
          indicatorColor: kTeal.withOpacity(.25)),
      dialogBackgroundColor: kCard,
    );
