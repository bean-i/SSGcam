import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:http/http.dart' as http;
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> messages = [];
  final AutoScrollController _scrollController =
      AutoScrollController(); // ScrollController 추가

  // 현재 사용자를 위한 사용자 객체 생성
  final types.User user = const types.User(id: 'user123');

  // Bot 사용자를 위한 사용자 객체 생성 (로컬 이미지 포함)
  final types.User botUser = const types.User(
    id: 'bot',
    firstName: 'Bot',
    imageUrl: 'assets/images/largeIcon.png', // 로컬 이미지 경로 설정
  );

  // 질문과 응답을 저장할 Map 정의
  final Map<String, String> predefinedResponses = {
    '📞 보이스피싱 대처 방안':
        '𝟭. 입금 금융회사 또는 송금 금융회사 콜센터에 즉시 전화하여 피해 신고 및 계좌 지급 정지를 신청해야 합니다.\n𝟮. 신분증, 계좌번호 등 개인정보가 유출되었거나 의심스러운 URL 접속으로 인해 악성앱 설치가 의심되는 경우 아래의 절차대로 행동합니다.\n   ⑴ 휴대전화 초기화나 악성 앱을 삭제(초기화 전까지 휴대전화 전원을 끄거나 비행기 모드로 전환)합니다.\n   ⑵ 금감원 개인정보 노출자 사고예방 시스템(pd.fss.or.kr)에 개인정보 노출사 실을 등록합니다.\n   ⑶ 금융결제원 계좌정보통합관리서비스(www.payinfo.or.kr)에서 본인 계좌에 대한 지급정지를 신청합니다.\n   ⑷ 명의도용된 휴대전화 개설 여부를 조회합니다.(명의도용 휴대전화가 개통된 경우, 즉시 해당 이동통신사에 신고합니다.)',
    '🚫 계좌 지급 정지 신청 방법':
        '⑴ 금융결제원 계좌정보통합관리서비스(www.payinfo.or.kr) 접속 합니다.\n⑵ 본인 계좌 지급정지 메뉴에서 은행권, 제2금융권, 증권사 클릭 합니다.\n⑶. 공동 인증서 및 휴대전화 인증(2중 인증)으로 본인 확인 합니다.\n⑷ 지급정지를 신청할 계좌를 선택 후 지급정지 신청 합니다.',
    '🔍 명의 도용 휴대전화 개설 조회':
        '⑴ 한국 정보통신진흥 협회 명의도용방지 서비스 ([www.msafer.or.kr](http://www.msafer.or.kr/)) 접속 합니다.\n⑵ 공동 인증서 등으로 로그인 합니다.\n⑶ 가입 사실 현황 조회 서비스 메뉴를 클릭하여, 본인 명의로 개설된 휴대전화 개설 사건 여부를 확인 합니다.\n⑷ 명의도용 휴대전화가 개통된 경우. 즉시 해당 이동통신사 등에 회선 해지 신청 및 명의도용 신고를 합니다.\n⑸ 가입제한 서비스 메뉴 클릭하여, 본인 명의 휴대전화 신규 개설 차단을 합니다.',
    '💸 피해금 환급 신청 방법':
        '𝟭. 금융감독원에 신고: 금융감독원의 보이스피싱 피해 신고센터(국번 없이 1332)로 전화하여 상담을 받고, 피해 신고 절차를 밟아야 합니다(금융감독원의 공식 웹사이트(www.fss.or.kr)에서도 관련 정보와 신고 방법을 찾을 수 있습니다.)\n𝟮. 피해금 환급 절차\n   ⑴ 피해 구제 신청: 경찰 신고와 함께 금융감독원에 피해 구제 신청을 합니다. 이때, 신고서, 피해 관련 증거 자료(계좌 이체 내역, 통화 기록 등)를 준비해 제출해야 합니다.\n   ⑵ 사건 조사: 신고를 받은 금융감독원과 경찰은 사건을 조사하여 피해 사실을 확인합니다.\n   ⑶ 금융기관의 조치: 조사 결과에 따라 금융기관은 피해금 환급 여부와 금액을 결정합니다. 전액이나 일부 환급이 가능할 수 있습니다.',
  };

  @override
  void initState() {
    super.initState();
    _sendInitialMessage();
  }

  // 초기 메시지 전송 함수
  void _sendInitialMessage() {
    final initialMessage = types.CustomMessage(
      author: botUser, // botUser 사용
      id: DateTime.now().toString(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      metadata: const {
        'text':
            '안녕하세요! 스윽캠 AI봇입니다.😀\n아래 내용 중 문의사항을 선택해 주세요!\n\n이외 문의는 아래 메시지로 보내주시기 바랍니다.',
      },
    );

    setState(() {
      messages.insert(0, initialMessage);
    });

    _scrollToBottom(); // 초기 메시지 전송 후 화면 아래로 스크롤
  }

  // 사용자가 메시지를 보낼 때 호출되는 함수
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: user,
      id: DateTime.now().toString(),
      text: message.text,
    );

    setState(() {
      messages.insert(0, textMessage);
      _showLoadingIndicator(); // 로딩 인디케이터 추가
    });

    _sendMessageToServer(message.text);
  }

  // 로딩 인디케이터를 메시지로 표시하는 함수
  void _showLoadingIndicator() {
    final loadingMessage = types.CustomMessage(
      author: botUser,
      id: 'loading',
      createdAt: DateTime.now().millisecondsSinceEpoch,
      metadata: const {
        'type': 'loading',
      },
    );

    setState(() {
      messages.insert(0, loadingMessage);
    });

    _scrollToBottom(); // 로딩 인디케이터 추가 후 화면 아래로 스크롤
  }

  Future<void> _sendMessageToServer(String message) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/chatbot'), // Node.js 서버 주소
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botReply = responseData['reply'];

        final botMessage = types.TextMessage(
          author: botUser,
          id: DateTime.now().toString(),
          text: botReply,
        );

        setState(() {
          messages.removeWhere((msg) => msg.id == 'loading'); // 로딩 메시지 제거
          messages.insert(0, botMessage); // 실제 응답 메시지 추가
        });

        _scrollToBottom(); // 응답 메시지 추가 후 화면 아래로 스크롤
      } else {
        print('Failed to connect to the server: ${response.body}');
        setState(() {
          messages.removeWhere((msg) => msg.id == 'loading'); // 로딩 메시지 제거
        });
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        messages.removeWhere((msg) => msg.id == 'loading'); // 로딩 메시지 제거
      });
    }
  }

  // 미리 정의된 질문 버튼이 눌렸을 때 호출되는 함수
  void _handlePredefinedQuestionPressed(String question) {
    final textMessage = types.TextMessage(
      author: user,
      id: DateTime.now().toString(),
      text: question,
      metadata: const {'isPredefined': true}, // 미리 정의된 질문
    );

    setState(() {
      messages.insert(0, textMessage);
      _showLoadingIndicator(); // 로딩 인디케이터 추가
    });

    // 미리 정의된 질문에 대한 응답 처리
    _handleResponse(question);
  }

  // 메시지에 대한 응답 처리 함수
  void _handleResponse(String message) {
    final response = predefinedResponses[message];
    if (response != null) {
      final botMessage = types.TextMessage(
        author: botUser, // botUser 사용
        id: DateTime.now().toString(),
        text: response,
      );

      setState(() {
        messages.removeWhere((msg) => msg.id == 'loading'); // 로딩 메시지 제거
        messages.insert(0, botMessage); // 실제 응답 메시지 추가
      });

      _scrollToBottom(); // 응답 메시지 추가 후 화면 아래로 스크롤
    }
  }

  // 스크롤을 아래로 이동하는 함수
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
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
          "AI 챗봇 대화",
          style: TextStyle(
            fontFamily: 'PretendardSemiBold',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              scrollController: _scrollController, // ScrollController 전달
              showUserAvatars: true, // 아바타 표시 활성화
              messages: messages,
              onSendPressed: _handleSendPressed,
              user: user,
              customMessageBuilder: (message, {required int messageWidth}) {
                return _buildInitialBotMessage(context, message);
              },
              theme: DefaultChatTheme(
                dateDividerTextStyle: const TextStyle(
                  color: Color(0xff8a8a8a),
                  fontFamily: 'PretendardSemiBold',
                  fontSize: 12,
                ),
                dateDividerMargin: const EdgeInsets.only(bottom: 12),
                inputMargin: const EdgeInsets.symmetric(
                    // horizontal: 24,
                    // vertical: 0, // 외부 마진 설정
                    ),
                inputPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20, // 내부 패딩 설정
                ),
                inputContainerDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                inputBackgroundColor: Colors.white,
                inputTextColor: const Color(0xff484c54),
                inputTextStyle: const TextStyle(
                  fontFamily: 'PretendardLight',
                  fontSize: 15,
                ),
                emptyChatPlaceholderTextStyle: const TextStyle(
                  fontFamily: 'PretendardMedium',
                ),
                receivedMessageBodyTextStyle:
                    const TextStyle(color: Colors.black),
                sentMessageBodyTextStyle: const TextStyle(color: Colors.black),
              ),
              l10n: const ChatL10nKo(inputPlaceholder: '메시지를 작성해 주세요...'),
              bubbleBuilder: (child,
                      {required message, required nextMessageInGroup}) =>
                  _bubbleBuilder(child, message, nextMessageInGroup),
              avatarBuilder: _avatarBuilder, // 커스텀 아바타 빌더 추가
            ),
          ),
        ],
      ),
    );
  }

  // 초기 메시지 UI를 빌드하는 함수
  Widget _buildInitialBotMessage(
      BuildContext context, types.CustomMessage message) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration(
        color: Color(0xfff2f2f2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message.metadata?['text'] ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'PretendardMedium',
                fontSize: 15,
              ),
            ),
          ),
          // 미리 정의된 질문 버튼들
          const SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: predefinedResponses.keys.map((question) {
              return SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.7, // 부모의 가로 크기와 동일하게 설정
                child: ElevatedButton(
                  onPressed: () {
                    _handlePredefinedQuestionPressed(question);
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.white,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'PretendardMedium',
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 메시지 버블을 빌드하는 함수
  Widget _bubbleBuilder(
      Widget child, types.Message message, bool nextMessageInGroup) {
    if (message is types.CustomMessage &&
        message.metadata?['type'] == 'loading') {
      return Container(
        margin: const EdgeInsets.only(left: 6),
        decoration: const BoxDecoration(
          color: Color(0xfff2f2f2), // 로딩 메시지의 배경색 설정
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Color(0xff212226),
            ), // 로딩 인디케이터
          ),
        ),
      );
    }

    if (message is types.TextMessage) {
      // 미리 정의된 질문 버튼을 눌렀을 때 생성되는 메시지
      if (message.metadata?['isPredefined'] == true) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // 미리 정의된 질문의 배경색 설정
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xffafafaf), // 보더라인 색상 설정
              width: 1, // 보더라인 두께 설정
            ),
          ),
          child: child,
        );
      }
      // 사용자가 직접 채팅으로 작성하는 메시지
      else if (message.author.id == user.id) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xff5ac6f6), // 보내는 메시지의 배경색 설정
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: child,
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(left: 6),
          decoration: const BoxDecoration(
            color: Color(0xfff2f2f2), // 받은 메시지의 배경색 설정
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: child,
        );
      }
    }
    return child;
  }

  // 아바타를 빌드하는 함수
  Widget _avatarBuilder(types.User user) {
    if (user.id == 'bot') {
      return const CircleAvatar(
        backgroundImage: AssetImage('assets/images/largeIcon.png'), // 로컬 이미지 사용
      );
    } else {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.imageUrl ?? ''),
      );
    }
  }
}
