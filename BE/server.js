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
});
