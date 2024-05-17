import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xff202226),
        title: const Text(
          "전화번호 검색",
          style: TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xfff3f3f3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 130),
              const Text(
                '아래 경찰청 홈페이지에서\n 전화/계좌번호 등\n사이버 사기피해 신고여부를 확인해 보세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff202226),
                  shadowColor: Colors.black,
                  elevation: 8, // 그림자의 높이를 설정하여 그림자가 보이게 합니다.
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 25,
                    right: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => _launchURL(
                    //'https://cyberbureau.police.go.kr/prevention/sub7.jsp?mid=020600'
                    'https://www.police.go.kr/www/security/cyber/cyber04.jsp'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞게 조정
                  children: [
                    Text(
                      '피싱 의심 전화·계좌번호 조회',
                      style: TextStyle(
                        fontFamily: 'PretendardSemiBold',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 5), // 텍스트와 아이콘 사이의 간격
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 40,
                    ), // 아이콘 추가
                  ],
                ),
              ),
              const SizedBox(height: 25),
              // Image.asset(
              //   'assets/images/hover.png',
              //   width: 45,
              // ),
              // const SizedBox(height: 25),
              const Text(
                '최근 3개월 동안 3회 이상 사이버범죄 신고시스템에\n신고 접수된 번호들과 비교합니다.',
                style: TextStyle(
                  fontFamily: 'PretendardLight',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
