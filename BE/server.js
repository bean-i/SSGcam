<<<<<<< HEAD
const axios = require('axios');
const fs = require('fs');
const express = require('express');
const bodyParser = require('body-parser');
const twilio = require('twilio');
const ffmpeg = require('fluent-ffmpeg');
const ffmpegInstaller = require('@ffmpeg-installer/ffmpeg');
const ffprobeInstaller = require('@ffprobe-installer/ffprobe');
const path = require('path');

const app = express();

const accountSid = 'ACcbba44d426fa93be3633feceea031ca9'; 
const authToken = 'e69917add2fe0cd4489bb11685ee6242';

ffmpeg.setFfmpegPath(ffmpegInstaller.path);
ffmpeg.setFfprobePath(ffprobeInstaller.path);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

const client = twilio(accountSid, authToken);

const downloadRecording = async (recordingUrl, filename, attempt = 1) => {
  try {
    const response = await axios({
      method: 'get',
      url: recordingUrl,
      responseType: 'stream',
      auth: {
        username: accountSid,
        password: authToken
      }
    });

    const writer = fs.createWriteStream(filename);
    response.data.pipe(writer);

    return new Promise((resolve, reject) => {
      writer.on('finish', resolve);
      writer.on('error', reject);
    });
  } catch (error) {
    console.error(`녹음 파일 다운로드 중 오류 발생 (시도 ${attempt}):`, error);
    if (attempt < 3) {
      console.log(`재시도 ${attempt + 1}...`);
      return downloadRecording(recordingUrl, filename, attempt + 1);
    } else {
      throw error;
    }
  }
};

let recordings = [];

// Twilio Webhook 핸들러
app.post('/voice', (req, res) => {
  const twilioData = req.body; // Twilio로부터 받은 데이터
  console.log('Twilio Webhook 데이터:', twilioData);

  const twiml = `<?xml version="1.0" encoding="UTF-8"?>
    <Response>
      <Say language="ko-KR" voice="Polly.Seoyeon">안녕하세요, 스윽캠입니다!</Say>
      <Record action="/handle-partial-recording" method="POST" maxLength="10" playBeep="true" />
    </Response>`;

  res.type('text/xml');
  res.status(200).send(twiml);
});

// 부분 녹음 파일 처리 핸들러 1
app.post('/handle-partial-recording', async (req, res) => {
  const recordingSid = req.body.RecordingSid; // 녹음 파일의 SID를 가져옵니다
  console.log(`Partial Recording SID: ${recordingSid}`);
  const recordingUrl = req.body.RecordingUrl + '.wav'; // 녹음 파일의 URL을 가져옵니다

  // 고유한 파일명 생성
  // const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  // const filename = `partial_${timestamp}.wav`;
  const filename = 'first.wav';

  try {
    await downloadRecording(recordingUrl, filename);
    console.log(`부분 녹음 파일이 성공적으로 저장되었습니다: ${filename}`);
    
    // 파일명 저장
    recordings.push(filename);

    // 새로운 녹음을 시작하도록 리디렉션
    const twiml = `<?xml version="1.0" encoding="UTF-8"?>
      <Response>
        <Record action="/handle-end-recording" method="POST" playBeep="true" />
      </Response>`;
    
    res.type('text/xml');
    res.status(200).send(twiml);
  } catch (error) {
    console.error('부분 녹음 파일 다운로드 중 오류 발생:', error);
    res.status(500).send('부분 녹음 파일 다운로드 중 오류가 발생했습니다.');
  }
});

// 부분 녹음 파일 처리 핸들러 2
app.post('/handle-end-recording', async (req, res) => {
  const recordingSid = req.body.RecordingSid; // 녹음 파일의 SID를 가져옵니다
  console.log(`Partial Recording SID: ${recordingSid}`);
  const recordingUrl = req.body.RecordingUrl + '.wav'; // 녹음 파일의 URL을 가져옵니다

  // 고유한 파일명 생성
  // const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  // const filename = `partial_${timestamp}.wav`;
  const filename = 'last.wav';

  try {
    await downloadRecording(recordingUrl, filename);
    console.log(`부분 녹음 파일이 성공적으로 저장되었습니다: ${filename}`);
    
    // 파일명 저장
    recordings.push(filename);

    const outputFilename = `merged.wav`;
    await mergeRecordings(recordings, outputFilename);
    console.log(`녹음 파일이 성공적으로 병합되었습니다: ${outputFilename}`);

    // 새로운 녹음을 시작하도록 리디렉션
    const twiml = `<?xml version="1.0" encoding="UTF-8"?>
      <Response>
        <Say>Hi</Say>
      </Response>`;

    
    res.type('text/xml');
    res.status(200).send(twiml);
  } catch (error) {
    console.error('부분 녹음 파일 다운로드 중 오류 발생:', error);
    res.status(500).send('부분 녹음 파일 다운로드 중 오류가 발생했습니다.');
  }
});

// 녹음 파일 합치기 함수
const mergeRecordings = async (inputFiles, outputFile) => {
  return new Promise((resolve, reject) => {
    const ffmpegCommand = ffmpeg();

    inputFiles.forEach(file => {
      ffmpegCommand.input(file);
    });

    ffmpegCommand
      .on('end', () => {
        console.log(`Merged file saved as ${outputFile}`);
        resolve();
      })
      .on('error', (err) => {
        console.error('Error merging files:', err);
        reject(err);
      })
      .mergeToFile(outputFile, './tempdir');
  });
};

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`서버가 포트 ${PORT}에서 실행 중입니다.`);
=======
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
                            message: '4 sentences have been transcribed.'
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
>>>>>>> uu
});
