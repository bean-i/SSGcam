import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
var logger4 = Logger();

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
