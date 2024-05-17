import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/permission.dart';

var logger = Logger();

void main() {
  logger.d("앱 시작");

  runApp(const MyApp());
}

// 초기 라우트 및 라우트 설정 정의
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '스윽캠',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/permissions': (context) => const PermissionScreen(),
      },
    );
  }
}