import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter/services.dart'; // FilteringTextInputFormatter를 사용하기 위해 추가
import 'package:ssgcam/config.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false; // 검색 여부를 추적하는 변수

  // URL을 열기 위한 함수
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 전화번호를 검색하는 함수
  Future<void> _searchPhoneNumber(String phoneNumber) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
      _hasSearched = true; // 검색이 수행되었음을 표시
    });

    try {
      // 서버에 GET 요청을 보내서 전화번호 검색
      final response = await http.get(
        Uri.parse('http://$ipAddress:3001/api/records/$phoneNumber'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(data);
        });
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 검색 결과를 빌드하는 함수
  Widget _buildSearchResult(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/alert.png',
            width: 50,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result['rc_fd_num'] ?? 'Unknown Number',
                style: const TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 30,
                ),
              ),
              Text(
                result['rc_fd_category'] ?? 'N/A',
                style: const TextStyle(
                  fontFamily: 'PretendardRegular',
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 추가 정보를 보여주는 UI
  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text(
          '검색 결과가 없습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PretendardMedium',
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          '경찰청 홈페이지에서도 전화/계좌번호 등\n사이버 사기피해 신고여부를 확인해 보세요.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PretendardMedium',
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff7AD1F7),
            elevation: 0,
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 15,
              right: 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => _launchURL(
              'https://www.police.go.kr/www/security/cyber/cyber04.jsp'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.policy_rounded,
                color: Colors.black,
                size: 28,
              ),
              SizedBox(width: 7),
              Text(
                '피싱 의심 전화·계좌번호 조회',
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
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
              const SizedBox(height: 100),
              const Text(
                '모르는 번호로 전화가 왔나요?\n스윽캠에서 검색해 보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              // 전화번호 입력 필드
              SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 9,
                      child: TextField(
                        cursorColor: Colors.black,
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
                        ],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              width: 1.5,
                              color: Colors.black, // 포커스 보더 색상 설정
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                              color: Color(0xff212226), // 기본 상태의 테두리 색상
                              width: 1.5, // 기본 상태의 테두리 굵기
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xff212226),
                          ),
                          labelText: '전화번호 입력',
                          labelStyle: const TextStyle(
                              fontFamily: 'PretendardSemibold',
                              color: Colors.grey),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff212226),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          onPressed: () {
                            final phoneNumber = _phoneNumberController.text;
                            if (phoneNumber.isNotEmpty) {
                              _searchPhoneNumber(phoneNumber);
                            }
                          },
                          child: const Text(
                            '검색',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'PretendardSemiBold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // 로딩 인디케이터 또는 검색 결과를 표시
              _isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: _searchResults.isEmpty && _hasSearched
                          ? _buildAdditionalInfo()
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                return _buildSearchResult(
                                    _searchResults[index]);
                              },
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
