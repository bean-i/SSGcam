const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const fs = require('fs');
// const path = require('path');
const WebSocket = require('ws'); 
const speech = require('@google-cloud/speech'); 
const https = require('https');

// Google Speech Client 초기화
const speechClient = new speech.SpeechClient({
  keyFilename: '/Users/soyujin/Desktop/ssgcam/BE/norse-habitat-422620-t0-035825b3081d.json' // 실제 경로로 교체
});

const app = express();

// SSL/TLS 인증서 불러오기
// const server = https.createServer({
//   key: fs.readFileSync('./3d0f-175-192-51-218.ngrok-free.app-key.pem'),
//   cert: fs.readFileSync('./3d0f-175-192-51-218.ngrok-free.app.pem')
// }, app);
const server = require('http').createServer(app);
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// 통화 대기 시킬때
// app.use(express.static('public'));
// app.post('/wait.xml', (req, res) => {
//   const filePath = path.join(__dirname, 'public', 'wait.xml');
//   fs.readFile(filePath, { encoding: 'utf-8' }, (err, data) => {
//       if (err) {
//           console.error('File reading error:', err);
//           return res.status(500).send('Error reading wait.xml file');
//       }
//       res.type('text/xml');
//       res.send(data);
//   });
// });

// Firebase Admin SDK 초기화
const serviceAccount = require('/Users/soyujin/Desktop/capstone/ssgcam-22c80-firebase-adminsdk-4xwg9-8133e65558.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Twilio Webhook 핸들러
app.post('/voice', (req, res) => {
  const twilioData = req.body; // Twilio로부터 받은 데이터
  console.log('Twilio Webhook 데이터:', twilioData);

  // FCM 메시지 생성 및 전송
  const message = {
    notification: {
      title: '전화 수신 알림',
      body: '새로운 전화가 도착했습니다.'
    },
    data: twilioData,
    topic: 'incoming_calls'
  };

  admin.messaging().send(message)
    .then((response) => {
      console.log('FCM 메시지 전송 완료:', response);

      const twiml = `<?xml version="1.0" encoding="UTF-8"?>
                    <Response>
                      <Stream url='wss://3d0f-175-192-51-218.ngrok-free.app'>
                      </Stream>
                      <Say language="ko-KR" voice="Polly.Seoyeon">안녕하세요, 스윽캠입니다!</Say>
                    </Response>`;
    
                    // Dial 태그 추가하기

      res.type('text/xml');
      res.status(200).send(twiml);
    })
    .catch((error) => {
      console.error('FCM 메시지 전송 실패:', error);
      res.status(500).send('Error');
    });
});

// WebSocket 서버 설정
const wss = new WebSocket.Server({ server });
wss.on('connection', function connection(ws) {
  console.log('Received audio data1');
  ws.on('message', function incoming(audioContent) {
    console.log('Received audio data');

    // Google Cloud Speech-to-Text 요청
    const request = {
      audio: {
        content: audioContent.toString('base64')
      },
      config: {
        encoding: 'MULAW',
        sampleRateHertz: 8000,
        languageCode: 'ko-KR'
      }
    };

    speechClient.recognize(request).then(data => {
      const results = data[0].results;
      const transcription = results.map(result => result.alternatives[0].transcript).join('\n');
      console.log(`Transcription: ${transcription}`);
      ws.send(`Transcribed Text: ${transcription}`);
    }).catch(err => {
      console.error('ERROR:', err);
    });
  });

  ws.send('Connection established. Ready to receive audio data.');
});

server.listen(3000, () => {
  console.log(`HTTP 및 WebSocket 서버가 포트 ${3000}에서 실행 중입니다.`);
});


wss.on('listening', () => {
  console.log('Server is listening on port 3000');
});
