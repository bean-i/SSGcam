import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// 로그인 화면
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15), // 버튼 사이 간격
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                // 회원가입 로직
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 40)),
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
