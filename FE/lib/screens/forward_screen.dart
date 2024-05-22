import 'package:flutter/material.dart';

class ForwardScreen extends StatelessWidget {
  const ForwardScreen({super.key});

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
          "착신 전환 설정",
          style: TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xfff3f3f3),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '착신 전환이란?',
                  style: TextStyle(
                    fontFamily: 'PretendardExtraBold',
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '걸려온 전화나 문자를 특정한 전화번호로\n전환시키는 기능 (통신사 부가 서비스)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardBold',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                // const Text(
                //   '전화기로 걸려오는 전화를 받지 못한 경우,\n다른 전화기의 전화번호로 받을 수 있도록 전화를 전환합니다.',
                //   style: TextStyle(
                //     fontFamily: 'PretendardBold',
                //     fontSize: 10,
                //   ),
                // ),
                // const SizedBox(height: 26),
                Image.asset('assets/images/callEX.png'),
                const SizedBox(height: 23),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  '스윽캠 + 착신 전환',
                  style: TextStyle(
                    fontFamily: 'PretendardExtraBold',
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '착신 전환 기능을 사용하여\n스윽캠 번호로 착신 전환 연결합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardBold',
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset('assets/images/ssgcamEX.png'),
                const SizedBox(height: 26),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                const Text(
                  '착신 전환 어떻게 하나요?',
                  style: TextStyle(
                    fontFamily: 'PretendardExtraBold',
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff559df4),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '첫 번째',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PretendardExtraBold',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '착신 전환 부가 서비스 신청하기',
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 17,
                    color: Color(0xff559df4),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '사용하고 계신 통신사의 착신 전환 부가 서비스를 신청하여\n이용할 수 있습니다.\n착신 전환 부가 서비스를 신청하지 않은 경우\n착신 전환이 불가능합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'PretendardMedium',
                      fontSize: 10,
                      color: Colors.black,
                      backgroundColor: Color(0xffC3EDFF),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '* ',
                        style: TextStyle(
                          fontFamily: 'PretendardMedium',
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: '통신사 착신 비용은 스윽캠 이용과 별도로 통신사에 지불해 주셔야 합니다.',
                        style: TextStyle(
                          fontFamily: 'PretendardMedium',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff559df4),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    '두 번째',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PretendardExtraBold',
                      fontSize: 17,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '착신 전환 설정하기',
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 17,
                    color: Color(0xff559df4),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '전화 키패드에서 스윽캠 번호로 착신 전환',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardSemiBold',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '*71+스위치 번호+통화하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardBold',
                    fontSize: 13,
                    backgroundColor: Color(0xffFFE145),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '전화 키패드에서\n[ *71 + 스위치 번호(착신 전환할 번호) + 통화버튼]\n을 눌러주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PretendardMedium',
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
