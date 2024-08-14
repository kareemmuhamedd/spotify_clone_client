import 'package:client/features/auth/view/screens/login_screen.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify App',
      theme: AppTheme.darkThemeMode,
      home: const SignupScreen(),
    );
  }
}
