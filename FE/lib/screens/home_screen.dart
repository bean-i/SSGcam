import 'package:flutter/material.dart';
import 'forward_screen.dart';
import 'chat_screen.dart';
import 'search_screen.dart';
import 'record_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Image.asset(
            'assets/images/logo.png',
            width: 78,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      backgroundColor: const Color(0xfff3f3f3),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          greetingCard(context),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 23,
            ),
            child: Column(
              children: [
                callForwarding(context),
                const SizedBox(height: 17),
                chatbotCard(context),
                const SizedBox(height: 17),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: searchCard(context),
                      ),
                      const SizedBox(width: 17),
                      Expanded(
                        child: recordCard(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget greetingCard(BuildContext context) {
  return Container(
    color: const Color(0xff6ab2f8), // 배경색 설정
    padding: const EdgeInsets.symmetric(
      vertical: 18,
      horizontal: 30,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'PretendardBold',
              fontSize: 32,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                text: '오늘 ',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                ),
              ),
              const TextSpan(
                text: '보이스피싱',
                style: TextStyle(
                  fontFamily: 'PretendardBold',
                ),
              ),
              const TextSpan(text: '\n'),
              TextSpan(
                text: ' 143건 ',
                style: TextStyle(
                  fontFamily: 'PretendardBold',
                  backgroundColor: Colors.white.withOpacity(0.7),
                ),
              ),
              const TextSpan(
                  text: '을\n잡았어요.',
                  style: TextStyle(
                    fontFamily: 'PretendardRegular',
                  )),
            ],
          ),
        ),
        Image.asset('assets/images/nyang.png', width: 116),
      ],
    ),
  );
}

Widget callForwarding(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ForwardScreen()), // 새로운 페이지로 이동
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '📞 착신 전환 설정',
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 20,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20,
                color: Color(0xff32363e),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 30,
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.all(9),
            width: double.infinity, // Container를 Column의 폭에 맞춤
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff939395),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff6ab2f8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '스윽캠 번호',
                    style: TextStyle(
                      fontFamily: 'PretendardExtraBold',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
                const Text(
                  '070-3392-9000',
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3), // 상단에만 공간 추가
                child: const Text(
                  '●',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xff6ab2f8),
                  ),
                ),
              ),
              const Text(
                ' 사용하는 이동 통신사의 착신 전환 부가 서비스로\n 스위치 번호를 착신 연결해주세요.',
                style: TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 14,
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget chatbotCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.only(
        top: 14,
        left: 15,
        right: 15,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '챗봇 대화하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 20,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20,
                color: Color(0xff32363e),
              )
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              SizedBox(
                width: 135,
                child: Image.asset('assets/images/chatIcon.png'),
              ),
              const SizedBox(width: 5),
              const Column(children: [
                Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xff28a0ee),
                    ),
                    Text(
                      ' 보이스피싱 대처 방안',
                      style: TextStyle(
                        fontFamily: 'PretendardLight',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xff28a0ee),
                    ),
                    Text(
                      ' 계좌 지급 정지 신청법',
                      style: TextStyle(
                        fontFamily: 'PretendardLight',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: Color(0xff28a0ee),
                    ),
                    Text(
                      ' 피싱 피해 환급 신청법',
                      style: TextStyle(
                        fontFamily: 'PretendardLight',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ])
            ],
          )
        ],
      ),
    ),
  );
}

Widget searchCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SearchScreen()), // 새로운 페이지로 이동
      );
    },
    child: Container(
      padding: const EdgeInsets.only(
        top: 12,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff7ad1f7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '🔍',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20,
                color: Color(0xff32363e),
              )
            ],
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Text(
                '전화번호 검색',
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            children: [
              Flexible(
                child: Text(
                  '의심 번호를 검색해 보세요.',
                  style: TextStyle(
                    fontFamily: 'PretendardLight',
                    overflow: TextOverflow.clip,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget recordCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const RecordScreen()), // 새로운 페이지로 이동
      );
    },
    child: Container(
      padding: const EdgeInsets.only(
        top: 12,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff7ac2f7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '📁',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 20,
                color: Color(0xff32363e),
              )
            ],
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Text(
                '탐지 기록',
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            children: [
              Flexible(
                child: Text(
                  '보이스피싱으로 탐지된 기록은 자동으로 저장됩니다.',
                  style: TextStyle(
                    fontFamily: 'PretendardLight',
                    overflow: TextOverflow.clip,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
