// lib/screens/record_screen.dart
import 'package:flutter/material.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RecordScreen"),
      ),
      body: const Center(
        child: Text("Welcome to the Chat screen!"),
      ),
    );
  }
}
