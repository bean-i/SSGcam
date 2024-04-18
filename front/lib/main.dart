import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

// MyApp 클래스는 애플리케이션의 루트 위젯입니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 위젯을 반환하여 앱의 기본 구조를 설정합니다.
    return MaterialApp(
      title: 'Call Initiator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// 전화 걸기 기능을 포함하는 홈 페이지의 상태 관리 클래스입니다.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// _MyHomePageState 클래스는 전화 걸기 버튼의 상태를 관리합니다.
class _MyHomePageState extends State<MyHomePage> {
  // 전화를 걸기 위한 함수입니다. HTTP GET 요청을 서버에 보냅니다.
  void makeCall() async {
    try {
      // http 패키지를 사용하여 GET 요청을 보냅니다.
      final response = await http.get(
        Uri.parse('http://localhost:3000/makeCall'),
      );

      // 서버로부터 응답을 받고 상태 코드가 200인 경우 성공적으로 요청이 처리된 것입니다.
      if (response.statusCode == 200) {
        // 성공 메시지를 표시하는 다이얼로그를 보여줍니다.
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Call initiated successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      } else {
        // 요청 실패 시 예외를 발생시킵니다.
        throw Exception('Failed to initiate call');
      }
    } catch (e) {
      // 오류 발생 시 오류 메시지를 표시하는 다이얼로그를 보여줍니다.
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold 위젯을 사용하여 앱의 기본 구조를 설정합니다.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make a Call'),
      ),
      body: Center(
        // 'Call Now' 버튼을 클릭하면 makeCall 함수가 호출됩니다.
        child: ElevatedButton(
          onPressed: makeCall,
          child: const Text('Call Now'),
        ),
      ),
    );
  }
}
