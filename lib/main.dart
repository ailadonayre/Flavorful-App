import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/app_theme.dart';
import 'screens/auth/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBwUAlKR51Ir192X2f4tmmpqaYhgB0-V6U',
        appId: '1:786700665264:android:47ceaf8eeb695884dbd675',
        messagingSenderId: '786700665264',
        projectId: 'flavorful-app',
        storageBucket: 'flavorful-app.firebasestorage.app',
      ),
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

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
      home: OnboardingScreen(),
    );
  }
}