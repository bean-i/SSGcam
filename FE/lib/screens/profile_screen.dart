// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart'; // main.dart 파일의 showNotification 함수 가져오기

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showNotification(
                    'Hi', 'This is a test notification from Profile Screen');
              },
              child: const Text('Show Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
