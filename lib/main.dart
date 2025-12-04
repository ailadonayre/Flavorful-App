import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_theme.dart';
import 'screens/auth/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env file FIRST
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY']!,
      appId: dotenv.env['APP_ID']!,
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
      projectId: dotenv.env['PROJECT_ID']!,
      storageBucket: dotenv.env['STORAGE_BUCKET']!,
    ),
  );

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
      home: const OnboardingScreen(),
    );
  }
}