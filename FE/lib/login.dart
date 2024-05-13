import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('아이디',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child :TextField(
                decoration: InputDecoration(
                  hintText: '아이디를 작성해 주세요.',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder( // 비활성화 상태의 테두리
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF549DEF),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스 받았을 때의 테두리
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF549DEF),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            const Text('비밀번호',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '비밀번호를 작성해 주세요.',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder( // 비활성화 상태의 테두리
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF549DEF),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder( // 포커스 받았을 때의 테두리
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF549DEF),
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child :ElevatedButton(
                onPressed: (){
                  // 로그인 로직
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xFF549DEF)),
                  minimumSize: MaterialStateProperty.all(const Size(120, 50)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),
                child: const Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: (){
                    // Navigator.pushNamed(context, '/');
                  },
                  child: const Text(
                    '아이디 찾기',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  '|',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 15),
                TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/permissions');
                  },
                  child: const Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
}