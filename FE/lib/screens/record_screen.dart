import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'audio_screen.dart';
import 'package:ssgcam/config.dart';

var logger4 = Logger();

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<dynamic> records = [];

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  //  탐지기록 가져오기
  Future<void> fetchRecords() async {
    final response =
        await http.get(Uri.parse('http://$ipAddress:3001/api/records'));
    if (response.statusCode == 200) {
      setState(() {
        records = json.decode(response.body);
      });
    } else {
      logger4.e('Failed to load records, status code: ${response.statusCode}');
      throw Exception('Failed to load records');
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
          "탐지 기록",
          style: TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xfff3f3f3),
        child: records.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return PhishingCard(item: records[index]);
                },
              ),
      ),
    );
  }
}

class PhishingCard extends StatelessWidget {
  final dynamic item;

  // 피해사례 등록
  Future<void> registerFraudCase(BuildContext context) async {
    logger4.e("피해 사례 등록 시도");
    try {
      final response = await http.post(
        Uri.parse('http://$ipAddress:3001/fraudcases'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fc_user': item['rc_user_id'],
          'fc_number': item['rc_fd_num'],
          'fc_description': item['rc_fd_category'],
          'fc_date': item['createdAt'],
        }),
      );
      if (response.statusCode == 201) {
        _showAlertDialog(context, "등록 완료",
            fc_number: item['rc_fd_num'],
            fc_description: item['rc_fd_category']);
      } else if (response.statusCode == 409) {
        _showAlertDialog(context, "등록 완료");
      }
    } catch (e) {
      logger4.e("피해 사례 등록 오류: $e");
    }
  }

  const PhishingCard({super.key, required this.item});

  void _showAlertDialog(BuildContext context, String title,
      {String? fc_number, String? fc_description}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: fc_number != null && fc_description != null
              ? Column(
                  mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용에 맞춤
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("번호: $fc_number",
                        style: const TextStyle(fontSize: 16)),
                    Text("등록 내용: $fc_description",
                        style: const TextStyle(fontSize: 16)),
                  ],
                )
              : const Text("이미 등록된 사례입니다.", style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "확인",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAudioPlayer(BuildContext context) {
    final audioFileId = item['rc_audio_file'];
    if (audioFileId == null || audioFileId.isEmpty) {
      logger4.e('오디오 파일 ID가 null이거나 비어 있습니다.');
      return;
    }
    final url = 'http://$ipAddress:3001/api/audio/$audioFileId';

    logger4.d('Requesting audio from URL: $url'); // 클라이언트 로그 추가

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AudioPlayerPage(
          audioUrl: url,
          date: item['createdAt'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _getDangerColor(item['rc_fd_level_str']),
                      width: 5.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['rc_fd_level_str'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        "${item['rc_fd_level']}%",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['rc_fd_num'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item['rc_fd_category'],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAudioPlayer(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    side: const BorderSide(
                      color: Color(0xFF79c2f7),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    '통화 내용 듣기',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // 피해 사례 DB 저장
                    registerFraudCase(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF79c2f7),
                    elevation: 0,
                    side: const BorderSide(
                      color: Color(0xFF79c2f7),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    '피해 사례 등록',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 27),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDangerColor(String level) {
    switch (level) {
      case '높음':
        return Colors.red;
      case '보통':
        return Colors.orange;
      case '낮음':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
