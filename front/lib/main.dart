import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/main_screen.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  logger.d("앱 시작");
  runApp(const MyApp());
}

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
        '/': (context) => const MainScreen(),
      },
    );
  }
}
