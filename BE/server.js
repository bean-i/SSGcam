process.env.GOOGLE_APPLICATION_CREDENTIALS = '/Users/ibeen/SSGcam/BE/ssgcam-e621d56cd3c1.json'

const app = require('./app'); // app.js에서 구성된 Express 앱을 가져옴.
const { Server: HttpServer } = require('http');
const WebSocket = require('ws');
const { SpeechClient } = require('@google-cloud/speech');
const stream = require('stream');
const helmet = require('helmet');

// HTTP 서버와 WebSocket 서버를 동일한 포트에서 실행
const server = new HttpServer(app);
const wss = new WebSocket.Server({ server });
const speechClient = new SpeechClient();

// 전역 변수로 recognizeStream 선언
let recognizeStream = null;

// Google STT 설정
const request = {
    config: {
        encoding: 'MULAW',  // 오디오 인코딩 타입, 실제 데이터에 맞게 조정 필요
        sampleRateHertz: 8000, // 샘플링 레이트, 실제 데이터에 맞게 조정 필요
        languageCode: 'ko-KR', // 한국어 설정
    },
    interimResults: true // 중간 결과를 반환하도록 설정
};

// Helmet을 설정하여 CSP를 포함
app.use(helmet.contentSecurityPolicy({
    directives: {
        defaultSrc: ["'self'"], // 기본 정책
        connectSrc: ["'self'", 'ws://localhost:3000', 'wss://localhost:3000'] // WebSocket 연결 허용 (보안 연결 포함)
    }
}));

let fullTranscription = '';  // 전체 텍스트를 저장할 변수
// 스트림 설정과 이벤트 리스너
function setupRecognizeStream() {
    if (recognizeStream && !recognizeStream.destroyed) {
        recognizeStream.end(); // 이전 스트림이 아직 종료되지 않았다면 종료
    }
    recognizeStream = speechClient.streamingRecognize(request)
        .on('error', error => {
            console.error('Speech-to-Text 에러:', error);
            setTimeout(setupRecognizeStream, 1000); // 에러 발생 후 재시도
        })
        .on('data', data => {
            const result = data.results[0];
            if (result && result.isFinal) {
                finalTranscription += result.alternatives[0].transcript + ' ';
                console.log('Transcription:', finalTranscription); // 최종 트랜스크립션 출력
            }
        });
}

let finalTranscription = ''; // 최종 인식된 전체 트랜스크립션 저장
let lastFinalContent = ''; // 마지막으로 확정된 텍스트 저장

function setupRecognizeStream() {
    recognizeStream = speechClient.streamingRecognize(request)
        .on('error', error => {
            console.error('Speech-to-Text 에러:', error);
            setTimeout(setupRecognizeStream, 1000);
        })
        .on('data', data => {
            const result = data.results[0];
            if (result) {
                const transcript = result.alternatives[0].transcript;

                if (result.isFinal) {
                    // 최종적으로 확정된 텍스트에 추가
                    finalTranscription += transcript + ' ';
                    console.log('Transcription:', finalTranscription); // 실시간으로 최종 트랜스크립션 출력
                } else {
                    // 중간 결과는 처리하지 않고 최종 결과만 처리
                }
            }
        });
}

// WebSocket 연결 관리
wss.on('connection', function connection(ws) {
    console.log("New Connection Initiated");

    // 클라이언트에게 단 한 번만 환영 메시지 보내기
    ws.send('Welcome to our WebSocket server!');

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
        // const messageString = message.toString();
        // try {
        //     const messageData = JSON.parse(messageString);

        //     if (messageData.event === 'media' && messageData.media.payload) {
        //         // Base64 인코딩된 오디오 데이터를 디코드합니다.
        //         const audioData = Buffer.from(messageData.media.payload, 'base64');

        //         if (recognizeStream && !recognizeStream.writableEnded) {
        //             recognizeStream.write(audioData);
        //         } else {
        //             console.log('스트림이 종료되었습니다. 재시작을 시도합니다.');
        //             setupRecognizeStream();
        //             recognizeStream.write(audioData);  // 새 스트림에 데이터 쓰기
        //         }
        //     }
        // } catch (error) {
        //     console.error('Error parsing message:', error);
        // }
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
           <Stream url='wss://97f6-115-91-214-4.ngrok-free.app' />
         </Start>
         <Say>
           Start speaking to see your audio transcribed in the console
         </Say>
         <Pause length='30' />
       </Response>`
    );
  });

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});