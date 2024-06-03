import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

var logger4 = Logger();

class AudioPlayerPage extends StatefulWidget {
  final String audioUrl;
  final String date;
  const AudioPlayerPage(
      {super.key, required this.audioUrl, required this.date});

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
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      final file = await _downloadFile(widget.audioUrl, 'audio.mp3');
      if (file != null) {
        await _audioPlayer.setSource(DeviceFileSource(file.path));
        logger4.d("오디오 파일 설정 완료: ${file.path}");

        _audioPlayer.onDurationChanged.listen((newDuration) {
          setState(() {
            duration = newDuration;
          });
          // logger4.d("오디오 길이: $duration");
        });

        _audioPlayer.onPositionChanged.listen((newPosition) {
          setState(() {
            position = newPosition;
          });
          // logger4.d("오디오 위치: $position");
        });

        _audioPlayer.onPlayerStateChanged.listen((state) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        });
      }
    } catch (e) {
      logger4.e("오디오 초기화 오류: $e");
    }
  }

  Future<File?> _downloadFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        logger4.e("파일 다운로드 오류: 상태 코드 ${response.statusCode}");
        return null;
      }
    } catch (e) {
      logger4.e("파일 다운로드 오류: $e");
      return null;
    }
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
      _audioPlayer.resume();
    }
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
        iconTheme: const IconThemeData(color: Colors.white),
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
