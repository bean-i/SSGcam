import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 180),
            // 사진
            SizedBox(
              width: 350,
              height: 300,
              child: Image.asset(
                'assets/images/welcome_image.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 50),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 페이지로 이동
                Navigator.pushNamed(context, '/login');
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color((0xFF549DEF))),
                minimumSize: WidgetStateProperty.all(const Size(270, 50)),
                elevation: WidgetStateProperty.all(0),
              ),
              child: const Text(
                '로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 회원가입 버튼
            ElevatedButton(
              onPressed: () {
                // 로그인 페이지로 이동
                Navigator.pushNamed(context, '/signup');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                minimumSize: WidgetStateProperty.all(const Size(270, 50)),
                elevation: WidgetStateProperty.all(0),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side:
                        const BorderSide(color: Color((0xFF549DEF)), width: 2),
                  ),
                ),
              ),
              child: const Text(
                '회원가입',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
