process.env.GOOGLE_APPLICATION_CREDENTIALS = '/Users/ibeen/SSGcam/BE/ssgcam-e621d56cd3c1.json';
require('dotenv').config(); // dotenv를 사용해 환경 변수 로드
const express = require('express');
const { Server: HttpServer } = require('http');
const WebSocket = require('ws');
const { SpeechClient } = require('@google-cloud/speech');
const helmet = require('helmet');
const axios = require('axios');
const fs = require('fs');
const bodyParser = require('body-parser');
const twilio = require('twilio');
const ffmpeg = require('fluent-ffmpeg');
const ffmpegInstaller = require('@ffmpeg-installer/ffmpeg');
const ffprobeInstaller = require('@ffprobe-installer/ffprobe');

const app = express();
const server = new HttpServer(app);
const wss = new WebSocket.Server({ server });
const speechClient = new SpeechClient();

const accountSid = 'ACcbba44d426fa93be3633feceea031ca9'; 
const authToken = 'e69917add2fe0cd4489bb11685ee6242';
const client = twilio(accountSid, authToken);

ffmpeg.setFfmpegPath(ffmpegInstaller.path);
ffmpeg.setFfprobePath(ffprobeInstaller.path);

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static('public'));

app.use(helmet.contentSecurityPolicy({
    directives: {
        defaultSrc: ["'self'"],
        connectSrc: ["'self'", 'ws://localhost:3000', 'wss://localhost:3000']
    }
}));

const request = {
    config: {
        encoding: 'MULAW',
        sampleRateHertz: 8000,
        languageCode: 'ko-KR',
        enableAutomaticPunctuation: true,
    },
    interimResults: true,
    singleUtterance: false
};

let recognizeStream = null;
let text = [];
let transcriptionCount = 0;

// function setupRecognizeStream() {
//     if (recognizeStream) {
//         recognizeStream.end();
//     }

//     recognizeStream = speechClient.streamingRecognize(request)
//         .on('error', error => {
//             console.error('Speech-to-Text 에러:', error);
//             setTimeout(setupRecognizeStream, 1000);
//         })
//         .on('data', async data => {
//             const result = data.results[0];
//             if (result && result.isFinal) {
//                 const transcript = result.alternatives[0].transcript;
//                 text.push(transcript);
//                 transcriptionCount++;
//                 console.log('Transcript:', transcript);

//                 if (transcriptionCount >= 4) {
//                     const fullText = text.join(' ');
//                     const transcriptData = { text: fullText };
//                     console.log('4문장이 완성되었습니다!', JSON.stringify(transcriptData, null, 2));

//                     try {
//                         await axios.post('http://192.168.0.2:4000/notify-event', {
//                             title: 'Transcript Complete',
//                             message: '4 sentences have been transcribed!'
//                         });
//                     } catch (error) {
//                         console.error('Error sending notification:', error);
//                     }

//                     text = [];
//                     transcriptionCount = 0;
//                 }
//             }
//         });
// }

function setupRecognizeStream() {
    if (recognizeStream) {
        recognizeStream.end();
    }

    recognizeStream = speechClient.streamingRecognize(request)
        .on('error', error => {
            console.error('Speech-to-Text 에러:', error);
            setTimeout(setupRecognizeStream, 1000);
        })
        .on('data', async data => {
            const result = data.results[0];
            if (result && result.isFinal) {
                const transcript = result.alternatives[0].transcript;
                text.push(transcript);
                transcriptionCount++;
                console.log('Transcript:', transcript);

                if (transcriptionCount >= 4) {
                    const fullText = text.join(' ');
                    const transcriptData = { text: fullText };
                    console.log('4문장이 완성되었습니다!', JSON.stringify(transcriptData, null, 2));

                    // AI 서버에 데이터 전송 및 결과 처리
                    try {
                        const response = await axios.post('http://172.30.1.94:5000/predict/voicephishing', transcriptData, {
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        });
                        console.log('AI 서버에 데이터를 성공적으로 보냈습니다.');

                        // AI 서버의 응답을 받아 플러터 앱에 알림 전송
                        const responseData = response.data;
                        const notificationMessage = `${responseData.probability} 확률로 ${responseData.voicephishing_class_results}으로 의심됩니다.`;
                        await sendNotificationToFlutter(notificationMessage);
                    } catch (error) {
                        console.error('AI 서버에 데이터 전송 중 오류 발생:', error);
                    }

                    text = [];
                    transcriptionCount = 0;
                }
            }
        });
}
// 플러터 앱에 알림을 전송하는 함수
async function sendNotificationToFlutter(data) {
    try {
        await axios.post('http://192.168.0.2:4000/notify-event', data, {
            headers: {
                'Content-Type': 'application/json'
            }
        });
        console.log('플러터 앱에 알림을 성공적으로 보냈습니다.');
    } catch (error) {
        console.error('플러터 앱에 알림 전송 중 오류 발생:', error);
    }
}


wss.on('connection', async function connection(ws) {
    console.log("New Connection Initiated");

    setupRecognizeStream();

    ws.on('message', function incoming(message) {
        const messageString = message.toString();
        try {
            const messageData = JSON.parse(messageString);

            if (messageData.event === 'media' && messageData.media.payload) {
                const audioData = Buffer.from(messageData.media.payload, 'base64');

                if (recognizeStream && !recognizeStream.writableEnded) {
                    recognizeStream.write(audioData);
                } else {
                    console.log('스트림이 종료되었습니다. 재시작을 시도합니다.');
                    setupRecognizeStream();
                    recognizeStream.write(audioData);
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

app.post("/", async (req, res) => {
    res.set("Content-Type", "text/xml");
    res.send(
      `<Response>
         <Start>
           <Stream url='wss://7056c16c724b.ngrok.app' />
         </Start>
         <Say>
           Hi Start speaking to see your audio transcribed in the console
         </Say>
         <Pause length='60' />
       </Response>`
    );
});

// Twilio Webhook 핸들러
app.post('/voice', (req, res) => {
    const twilioData = req.body;
    console.log('Twilio Webhook 데이터:', twilioData);

    const twiml = `<?xml version="1.0" encoding="UTF-8"?>
    <Response>
        <Say language="ko-KR" voice="Polly.Seoyeon">안녕하세요, 스윽캠입니다!</Say>
        <Record action="/handle-partial-recording" method="POST" maxLength="10" playBeep="true" />
    </Response>`;

    res.type('text/xml');
    res.status(200).send(twiml);
});

const recordings = []; // 녹음 파일 배열

// 부분 녹음 파일 처리 핸들러 1
app.post('/handle-partial-recording', async (req, res) => {
    const recordingSid = req.body.RecordingSid;
    console.log(`Partial Recording SID: ${recordingSid}`);
    const recordingUrl = req.body.RecordingUrl + '.wav';

    const filename = 'first.wav';

    try {
        await downloadRecording(recordingUrl, filename);
        console.log(`부분 녹음 파일이 성공적으로 저장되었습니다: ${filename}`);

        recordings.push(filename);

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
    const recordingSid = req.body.RecordingSid;
    console.log(`Partial Recording SID: ${recordingSid}`);
    const recordingUrl = req.body.RecordingUrl + '.wav';

    const filename = 'last.wav';

    try {
        await downloadRecording(recordingUrl, filename);
        console.log(`부분 녹음 파일이 성공적으로 저장되었습니다: ${filename}`);

        recordings.push(filename);

        const outputFilename = `merged.wav`;
        await mergeRecordings(recordings, outputFilename);
        console.log(`녹음 파일이 성공적으로 병합되었습니다: ${outputFilename}`);

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

// 녹음 파일 다운로드 함수
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

// 기존의 chatbotRoutes 내용을 여기로 합침
const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

app.post('/chatbot', async (req, res) => {
  const userMessage = req.body.message;
  console.log('Received message:', userMessage);

  let attempts = 0;
  const maxAttempts = 3;
  const retryDelay = 1000; // 1초

  while (attempts < maxAttempts) {
    try {
      const response = await axios.post(
        'https://api.openai.com/v1/chat/completions',
        {
          model: 'gpt-3.5-turbo',
          messages: [
            { role: 'system', content: 'You are an expert in voice phishing prevention who knows South Korean laws and regulations well. Please provide concise but detailed and accurate information.' },
            { role: 'user', content: userMessage }
          ],
          max_tokens: 500, // Increase the max_tokens to allow longer responses
          n: 1,
          stop: ["\n"],
          temperature: 0.5,
        },
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          },
        }
      );

      console.log('OpenAI response:', response.data);
      return res.json({ reply: response.data.choices[0].message.content.trim() });
    } catch (error) {
      if (error.response && error.response.status === 429) {
        attempts += 1;
        console.error('Too many requests, retrying in', retryDelay, 'ms');
        await wait(retryDelay);
      } else {
        console.error('Error fetching response from OpenAI:', error);
        return res.status(500).json({ error: 'Failed to fetch response from ChatGPT' });
      }
    }
  }

  res.status(500).json({ error: 'Exceeded maximum retry attempts.' });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
