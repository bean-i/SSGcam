import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<types.Message> messages = [];

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
    '📞 보이스피싱 대처 방안': '보이스피싱 대처 방안은 다음과 같습니다...',
    '🚫 계좌 지급 정지 신청 방법': '계좌 지급 정지 신청 방법은 다음과 같습니다...',
    '💸 피해금 환급 신청 방법': '피해금 환급 신청 방법은 다음과 같습니다...',
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
    });

    // 사용자가 직접 입력한 메시지에 대한 응답 처리 (예시로 미리 정의된 응답 사용)
    _handleResponse(message.text);
  }

  // 미리 정의된 질문 버튼이 눌렸을 때 호출되는 함수
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
        messages.insert(0, botMessage);
      });
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
