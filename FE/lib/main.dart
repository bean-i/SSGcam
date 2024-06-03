import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:audio_session/audio_session.dart';
import 'screens/main_screen.dart';
import 'screens/onboarding.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/permission.dart';

var logger = Logger();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 플러그인 초기화
  logger.d("앱 시작");

  // final AudioContext audioContext = AudioContext(
  //   iOS: AudioContextIOS(
  //     defaultToSpeaker: true,
  //     category: AVAudioSessionCategory.ambient,
  //     options: [
  //       AVAudioSessionOptions.defaultToSpeaker,
  //       AVAudioSessionOptions.mixWithOthers,
  //     ],
  //   ),
  //   android: AudioContextAndroid(
  //     isSpeakerphoneOn: true,
  //     stayAwake: true,
  //     contentType: AndroidContentType.sonification,
  //     usageType: AndroidUsageType.assistanceSonification,
  //     audioFocus: AndroidAudioFocus.none,
  //   ),
  // );
  // AudioPlayer.global.setGlobalAudioContext(audioContext);

  // 알림 초기화 설정
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings =
      InitializationSettings(iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
  // IP 주소를 가져오는 함수 호출
  String ipAddress = await getLocalIpAddress();
  logger.d('Device IP Address: $ipAddress');
  startServer(ipAddress); // IP 주소를 서버 시작 함수로 전달
}

// IP 주소를 가져오는 함수
Future<String> getLocalIpAddress() async {
  for (var interface in await NetworkInterface.list()) {
    for (var address in interface.addresses) {
      if (address.type == InternetAddressType.IPv4 && !address.isLoopback) {
        return address.address;
      }
    }
  }
  return '127.0.0.1'; // 기본 IP 주소
}

// HTTP 서버를 시작하는 메서드
Future<void> startServer(String ipAddress) async {
  HttpServer server =
      await HttpServer.bind(InternetAddress.anyIPv4, 4000); // 포트 번호를 4000으로 변경
  server.listen((HttpRequest request) async {
    if (request.method == 'POST' && request.uri.path == '/notify-event') {
      String content = await utf8.decoder.bind(request).join();
      Map<String, dynamic> data = json.decode(content);
      showNotification(data['title'], data['message']);
      request.response
        ..statusCode = HttpStatus.ok
        ..write('Notification sent')
        ..close();
    }
  });
  logger.d("서버 시작됨: 포트 4000, IP 주소: $ipAddress");
}

// 로컬 알림을 표시하는 메서드
Future<void> showNotification(String title, String message) async {
  var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
  var platformChannelSpecifics =
      NotificationDetails(iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin
      .show(0, title, message, platformChannelSpecifics, payload: 'item x');
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
        '/main': (context) => const MainScreen(),
      },
    );
  }
}
