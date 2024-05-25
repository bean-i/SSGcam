import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:just_audio/just_audio.dart';

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

  Future<void> fetchRecords() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/records'));
    logger4.d('HTTP GET /api/records status: ${response.statusCode}');
    if (response.statusCode == 200) {
      logger4.d('HTTP GET /api/records response body: ${response.body}');
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

  const PhishingCard({super.key, required this.item});

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(
            child: Text(
              "등록이 완료되었습니다.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("번호: ${item['rc_fd_num']}"),
              Text("등록 내용: ${item['rc_fd_category']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  "확인",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
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
    final url = 'http://10.0.2.2:3000/api/audio/$audioFileId';

    logger4.d('Requesting audio from URL: $url');  // 클라이언트 로그 추가

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
                      color: _getDangerColor(item['rc_fd_level']),
                      width: 5.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item['rc_fd_level'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        "${item['rc_fd_percentage']}%",
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
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(0),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Color(0xFF79c2f7),
                        width: 1.5,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                    _showAlertDialog(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xFF79c2f7)),
                    elevation: MaterialStateProperty.all(0),
                    side: MaterialStateProperty.all(
                      const BorderSide(
                        color: Color(0xFF79c2f7),
                        width: 1.5,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final String date;
  const AudioPlayerPage({super.key, required this.audioUrl, required this.date});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  @override
  void initState() {
    super.initState();
    logger4.d("오디오 연결 : ${widget.audioUrl}");
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.audioUrl).then((_) {
      _audioPlayer.durationStream.listen((newDuration) {
        setState(() {
          duration = newDuration ?? Duration.zero;
        });
      });
      _audioPlayer.positionStream.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
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
        title: Text(
          widget.date,
          style: const TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.grey,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Slider(
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(newPosition);
                      await _audioPlayer.play();
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 64,
                        onPressed: _togglePlayPause,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
