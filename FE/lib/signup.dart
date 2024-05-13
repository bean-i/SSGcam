import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{
  // `TextField` 위젯들을 저장할 리스트
  List<Widget> contactFields = [];

  @override
  void initState() {
    super.initState();
    // 초기에 하나의 `TextField`를 추가
    addContactField();
  }

  void addContactField() {
    if (contactFields.length < 6) {  // 최대 3개까지 추가 가능
      var newField = createContactField();
      setState(() {
        contactFields.add(newField);
        contactFields.add(const SizedBox(height: 10));
      });
    }
  }

  createContactField() {
    return SizedBox(
      height: 50,
      child :TextField(
        decoration: InputDecoration(
          hintText: 'ex) 010-1111-2222',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,  // 빨간색으로 표시
                        fontSize: 16,  // 폰트 크기 맞춤
                        fontWeight: FontWeight.bold,  // 굵은 글씨체
                      ),
                    ),
                    TextSpan(
                      text: ' 이름',
                      style: TextStyle(
                        color: Colors.black,  // 검은색으로 표시
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child :TextField(
                  decoration: InputDecoration(
                    hintText: '이름을 작성해 주세요.',
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
              const SizedBox(height: 30),
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,  // 빨간색으로 표시
                        fontSize: 16,  // 폰트 크기 맞춤
                        fontWeight: FontWeight.bold,  // 굵은 글씨체
                      ),
                    ),
                    TextSpan(
                      text: ' 아이디',
                      style: TextStyle(
                        color: Colors.black,  // 검은색으로 표시
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 6, bottom: 6, right: 6),
                        child: TextButton(
                          onPressed: () {

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color(0xFF549DEF)),
                            minimumSize: MaterialStateProperty.all(const Size(60, 30)), // 최소 사이즈 조절
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                          ),
                          child: const Text(
                            '중복 확인',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,  // 빨간색으로 표시
                        fontSize: 16,  // 폰트 크기 맞춤
                        fontWeight: FontWeight.bold,  // 굵은 글씨체
                      ),
                    ),
                    TextSpan(
                      text: ' 비밀번호',
                      style: TextStyle(
                        color: Colors.black,  // 검은색으로 표시
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child :TextField(
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
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,  // 빨간색으로 표시
                        fontSize: 16,  // 폰트 크기 맞춤
                        fontWeight: FontWeight.bold,  // 굵은 글씨체
                      ),
                    ),
                    TextSpan(
                      text: ' 비밀번호 확인',
                      style: TextStyle(
                        color: Colors.black,  // 검은색으로 표시
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child :TextField(
                  decoration: InputDecoration(
                    hintText: '비밀번호를 확인해 주세요.',
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
              const SizedBox(height: 30),
              const Text('보호자 연락처',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              const Text('보이스피싱 전화 수신 시, 보호자에게 알림이 갑니다.',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              ...contactFields,
              contactFields.length > 5 ? const SizedBox() : Center(
                child: IconButton(
                  icon: const Icon(Icons.add, size: 35),
                  onPressed: addContactField,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(60.0,30.0,60.0,30.0),
        child: ElevatedButton(
          onPressed: () {
            // 회원가입 로직
          },
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ),
    );
  }

}