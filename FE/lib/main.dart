import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'onboarding.dart';
import 'login.dart';
import 'signup.dart';
import 'permission.dart';

var logger = Logger();

void main() {
  logger.d("앱 시작");

  runApp(MyApp());
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
        '/': (context) => OnboardingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/permissions': (context) => PermissionScreen(),
      },
    );
  }
}



//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//
//   @override
//   void initState() {
//     super.initState();
//     nativeCall();  // 이벤트 채널 구독 시작
//   }
//
//   // 전화오면 일단 이 화면이 변하도록
//   Future<Null> nativeCall() async{
//     const channel = EventChannel('eventChannel');
//     logger.d("구독 시작");
//     channel.receiveBroadcastStream().listen((dynamic event) {
//       // 이벤트를 받았을 때 실행할 코드
//       logger.d("이벤트 수신");
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => const CallScreen()),
//       );
//     }, onError: (dynamic error) {
//       print('bye');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // 로그인 버튼
//             ElevatedButton(
//               onPressed: () {
//               },
//               style: ButtonStyle(
//                 minimumSize: MaterialStateProperty.all(const Size(200, 40)),
//                 elevation: MaterialStateProperty.all(0),
//                 backgroundColor: MaterialStateProperty.all(Colors.blue),
//               ),
//               child: const Text(
//                 '로그인',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 15), // 버튼 사이 간격
//             // 회원가입 버튼
//             ElevatedButton(
//               onPressed: () {
//                 // 회원가입 로직
//               },
//               style: ButtonStyle(
//                 minimumSize: MaterialStateProperty.all(const Size(200, 40)),
//                 elevation: MaterialStateProperty.all(0),
//                 backgroundColor: MaterialStateProperty.all(Colors.white),
//                 shape: MaterialStateProperty.all(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                     side: const BorderSide(color: Colors.blue, width: 2),
//                   ),
//                 ),
//               ),
//               child: const Text('회원가입'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // 전화 이벤트 처리(Android)
// class NativeEvents {
//   static const EventChannel _eventChannel = EventChannel('com.example.front/events');
//
//   void listenToNativeEvents(BuildContext context) {
//     _eventChannel.receiveBroadcastStream().listen(
//           (dynamic event) {
//         // 여기서 받은 이벤트에 따라 원하는 UI를 띄우는 로직 구현
//         logger.d("Received event: $event");
//         if(event == 'ringing') {
//           // 전화가 오는 이벤트를 받았을 때의 UI 처리
//           logger.d("Call OK");
//           // Navigator.of(context).push(
//           //   MaterialPageRoute(builder: (context) => const CallScreen()),
//           // );
//         }
//       },
//       onError: (dynamic error) {
//         logger.d("Received error: ${error.message}");
//       },
//     );
//   }
// }
//
// // 전화 수신 화면(Android)
// class CallScreen extends StatelessWidget {
//   const CallScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Incoming Call"),
//       ),
//       body: const Center(
//         child: Text("You have an incoming call!", style: TextStyle(fontSize: 24)),
//       ),
//     );
//   }
// }
