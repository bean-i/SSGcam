process.env.GOOGLE_APPLICATION_CREDENTIALS = '/Users/ibeen/SSGcam/BE/ssgcam-e621d56cd3c1.json';

const app = require('./app'); // app.js에서 구성된 Express 앱을 가져옴.
const { Server: HttpServer } = require('http');
const WebSocket = require('ws');
const { SpeechClient } = require('@google-cloud/speech');
const helmet = require('helmet');
const axios = require('axios');

// HTTP 서버와 WebSocket 서버를 동일한 포트에서 실행
const server = new HttpServer(app);
const wss = new WebSocket.Server({ server });
const speechClient = new SpeechClient();

// Google STT 설정
const request = {
    config: {
        encoding: 'MULAW',
        sampleRateHertz: 8000,
        languageCode: 'ko-KR',
        enableAutomaticPunctuation: true,
    },
    interimResults: true
};

// Helmet을 설정하여 CSP를 포함
app.use(helmet.contentSecurityPolicy({
    directives: {
        defaultSrc: ["'self'"], // 기본 정책
        connectSrc: ["'self'", 'ws://localhost:3000', 'wss://localhost:3000'] // WebSocket 연결 허용 (보안 연결 포함)
    }
}));

let recognizeStream = null;
let text = []; // 최종 인식된 트랜스크립션을 저장할 배열
let transcriptionCount = 0; // 트랜스크립션 카운트

// 스트림 설정과 이벤트 리스너
function setupRecognizeStream() {
    if (recognizeStream) {
        recognizeStream.end(); // 이전 스트림이 아직 종료되지 않았다면 종료
    }

    recognizeStream = speechClient.streamingRecognize(request)
        .on('error', error => {
            console.error('Speech-to-Text 에러:', error);
            setTimeout(setupRecognizeStream, 1000); // 에러 발생 후 재시도
        })
        .on('data', async data => {
            const result = data.results[0];
            if (result && result.isFinal) {
                const transcript = result.alternatives[0].transcript;
                text.push(transcript);
                transcriptionCount++;
                console.log('Transcript:', transcript); // 매 문장마다 출력

                if (transcriptionCount >= 4) {
                    const fullText = text.join(' '); // 배열을 문자열로 변환 (콤마 없이 줄글로 이어줌)
                    const transcriptData = {
                        text: fullText
                    };
                    console.log('4문장이 완성되었습니다!', JSON.stringify(transcriptData, null, 2));
                    
                    // 알람 울리기
                    try {
                        await axios.post('http://192.168.0.2:4000/notify-event', {
                            title: 'Transcript Complete',
                            message: '4 sentences have been transcribed!'
                        });
                    } catch (error) {
                        console.error('Error sending notification:', error);
                    }
                    

                    // AI 서버에 데이터 전송
                    // try {
                    //     const response = await axios.post('http://localhost:5000/predict/voicephishing', transcriptData);
                    //     console.log('AI 서버 응답:', response.data);
                    // } catch (error) {
                    //     console.error('AI 서버 요청 중 에러 발생:', error);
                    // }

                    text = []; // 트랜스크립션 배열 초기화
                    transcriptionCount = 0; // 카운트 초기화
                }
            }
        });
}

// WebSocket 연결 관리
wss.on('connection', async function connection(ws) {
    console.log("New Connection Initiated");

    setupRecognizeStream();  // 연결 시 스트림 설정

    ws.on('message', function incoming(message) {
        const messageString = message.toString();
        try {
            const messageData = JSON.parse(messageString);

            if (messageData.event === 'media' && messageData.media.payload) {
                // Base64 인코딩된 오디오 데이터를 디코드합니다.
                const audioData = Buffer.from(messageData.media.payload, 'base64');

                if (recognizeStream && !recognizeStream.writableEnded) {
                    recognizeStream.write(audioData);
                } else {
                    console.log('스트림이 종료되었습니다. 재시작을 시도합니다.');
                    setupRecognizeStream();
                    recognizeStream.write(audioData);  // 새 스트림에 데이터 쓰기
                }
            }
        } catch (error) {
            console.error('Error parsing message:', error);
        }
    });

    ws.on('close', () => {
        console.log('WebSocket connection closed');
        recognizeStream.end();
    });
});

app.get('/', (req, res) => {
    res.send('Hello World!');
});

app.post("/", async (req, res) => {
    res.set("Content-Type", "text/xml");
    res.send(
      `<Response>
         <Start>
           <Stream url='wss://c09e19f11a32.ngrok.app' />
         </Start>
         <Say>
           Hi Start speaking to see your audio transcribed in the console
         </Say>
         <Pause length='60' />
       </Response>`
    );
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
