import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_theme.dart';
import 'screens/auth/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const FlavorfulApp());
}

class FlavorfulApp extends StatelessWidget {
  const FlavorfulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flavorful.',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: OnboardingScreen(), // Start with onboarding
    );
  }
}
