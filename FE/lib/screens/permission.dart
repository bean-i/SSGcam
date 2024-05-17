import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

var logger3 = Logger();

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: SizedBox(
                width: 150,
                height: 70,
                child: Image.asset(
                  'assets/images/blueLogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '앱을 사용하기 위해서 권한 허용이 필요합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 400,
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10), // 상단에 10 픽셀의 패딩 추가
                    child: Icon(
                      Icons.mic_none,
                      color: Colors.black,
                      size: 44.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 230,
                    height: 100,
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '마이크',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '통화 중에 사용자의 음성을 전달하기 위해 마이크 접근 권한이 필요합니다.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 400,
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10), // 상단에 10 픽셀의 패딩 추가
                    child: Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                      size: 44.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 230,
                    height: 100,
                    alignment: Alignment.centerLeft,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '알림',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '통화 알림과 보이스피싱 경고를 제공하기 위해 알림 기능이 필요합니다.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 200),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      // 권한 허용 로직
                      var microphoneStatus =
                          await Permission.microphone.request(); // 마이크 권한 요청
                      var notificationStatus =
                          await Permission.notification.request(); // 알림 권한 요청

                      if (microphoneStatus.isGranted &&
                          notificationStatus.isGranted) {
                        // 권한이 모두 허용된 경우
                        logger3.d("권한이 모두 허용됨");
                      } else {
                        // 하나 또는 두 권한 모두 거부된 경우
                        logger3.d("권한이 거부됨");
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF549DEF)),
                      minimumSize: MaterialStateProperty.all(const Size(270, 60)),
                      elevation: MaterialStateProperty.all(0),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                    ),
                    child: const Text(
                      '권한 허용',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
