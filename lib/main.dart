import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(FlavorfulApp());
}

class FlavorfulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flavorful.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
    );
  }
}