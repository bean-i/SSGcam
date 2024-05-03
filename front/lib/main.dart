import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    initializeFirebaseMessaging();
  }

  void initializeFirebaseMessaging() {
    messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data.containsKey('fromNumber')) {
      final String fromNumber = message.data['fromNumber'];
      showCallkitIncoming(fromNumber);
    }
  }

  Future<void> showCallkitIncoming(String fromNumber) async {
    final String uuid = const Uuid().v4();
    await FlutterCallkitIncoming.showCallkitIncoming(CallKitParams(
      id: uuid,
      nameCaller: 'Unknown',
      appName: 'MyApp',
      handle: fromNumber,
      type: 0, // 0 for audio call
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        ringtonePath: 'system_ringtone_default',
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Incoming Call')),
        body: const Center(child: Text('Hi, Waiting for incoming calls...')),
      ),
    );
  }
}
