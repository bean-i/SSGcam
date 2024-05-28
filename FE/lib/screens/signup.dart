import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'main_screen.dart';

var logger2 = Logger();

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  List<TextEditingController> _contactControllers = [];

  List<Widget> contactFields = []; // `TextField` 위젯들을 저장할 리스트

  @override
  void initState() {
    super.initState();
    addContactField(); // 초기에 하나의 `TextField`를 추가
  }

  void addContactField() {
    if (contactFields.length < 6) {  // 최대 3개까지 추가 가능
      var newController = TextEditingController();
      _contactControllers.add(newController);
      var newField = createContactField(newController);
      setState(() {
        contactFields.add(newField);
        contactFields.add(const SizedBox(height: 10));
      });
    }
  }

  createContactField(TextEditingController controller) {
    return SizedBox(
      height: 50,
      child :TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'ex) 010-1111-2222',
          hintStyle: const TextStyle(fontSize: 14),
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
    );
  }

// 백엔드와 연결
  Future<void> _register() async {
    String name = _nameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    List<String> contacts = _contactControllers.map((controller) => controller.text).toList();

    var url = Uri.parse('http://10.0.2.2:3000/register');

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'username': username,
        'password': password,
        'confirmPassword': confirmPassword,
        'parentContact': contacts,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        // logger2.d("회원가입 성공");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("회원가입에 성공했습니다!"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        // 회원가입 실패 처리
        logger2.d("회원가입 실패: ${jsonResponse['message']}");
      }
    } else {
      // 서버 오류 처리
      logger2.d('서버 오류: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField('이름', '이름을 작성해 주세요.', _nameController),
              const SizedBox(height: 30),
              _buildTextField('아이디', '아이디를 작성해 주세요.', _usernameController, suffix: '중복 확인'),
              const SizedBox(height: 30),
              _buildTextField('비밀번호', '비밀번호를 작성해 주세요.', _passwordController, obscureText: true),
              const SizedBox(height: 30),
              _buildTextField('비밀번호 확인', '비밀번호를 확인해 주세요.', _confirmPasswordController, obscureText: true),
              const SizedBox(height: 30),
              const Text('보호자 연락처', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              const Text('보이스피싱 전화 수신 시, 보호자에게 알림이 갑니다.', style: TextStyle(fontSize: 10)),
              const SizedBox(height: 2),
              ...contactFields,
              contactFields.length > 5
                  ? const SizedBox()
                  : Center(
                child: IconButton(
                  icon: const Icon(Icons.add, size: 35),
                  onPressed: addContactField,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(60.0, 30.0, 60.0, 30.0),
        child: ElevatedButton(
          onPressed: _register,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF549DEF)),
            minimumSize: MaterialStateProperty.all(const Size(100, 50)),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: Color((0xFF549DEF)), width: 2),
              ),
            ),
          ),
          child: const Text(
            '회원 가입',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {String? suffix, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '*',
                style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' $label',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Color(0xFF549DEF), width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(color: Color(0xFF549DEF), width: 2.0),
              ),
              suffixIcon: suffix != null
                  ? Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6, right: 6),
                child: TextButton(
                  onPressed: () {
                    // 중복 확인 로직
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF549DEF)),
                    minimumSize: MaterialStateProperty.all(const Size(60, 30)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    suffix,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
