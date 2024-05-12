// lib/screens/forward_screen.dart
import 'package:flutter/material.dart';

class ForwardScreen extends StatelessWidget {
  const ForwardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff202226),
        title: const Text(
          "착신 전환 설정",
          style: TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      body: const Center(
        child: Text("Welcome to the second screen!"),
      ),
    );
  }
}
