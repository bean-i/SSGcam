const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');
const fs = require('fs');
const path = require('path');
const Record = require('./Record'); // Record 모델 가져오기
const config = require('../config/key');
const express = require('express');
const app = express();

// MongoDB 연결 설정
mongoose.connect(config.mongoURI).then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err));

const conn = mongoose.connection;
let gfsBucket;
conn.once('open', () => {
  gfsBucket = new GridFSBucket(conn.db, { bucketName: 'uploads' });
  console.log('GridFSBucket is ready');
  insertRecord(); // 데이터 삽입 함수 호출
});

conn.on('error', (err) => {
  console.error('Mongoose connection error:', err);
});

// 임의 데이터 삽입 함수
const insertRecord = async () => {
  try {
    // 오디오 파일 경로 설정
    const audioFilePath = path.join(__dirname, 'test.wav'); // audio.wav 파일의 경로

    // 오디오 파일을 GridFS에 저장
    const writestream = gfsBucket.openUploadStream('audio.wav', {
      contentType: 'audio/wav',
    });

    fs.createReadStream(audioFilePath).pipe(writestream);

    writestream.on('finish', async () => {
      console.log('Audio file stored with ID:', writestream.id);

      // 레코드 생성 및 저장
      const newRecord = new Record({
        rc_user_id: '664de1470fc95dd030c902d5',
        rc_fd_num: '010-1111-4444',
        rc_fd_category: '기타',
        rc_fd_level: 66,
        rc_audio_file: writestream.id, // GridFS 파일 ID 사용
      });

      const result = await newRecord.save();
      console.log('Record inserted:', result);

      // 연결 종료
      mongoose.connection.close();
    });

    writestream.on('error', (err) => {
      console.error('Error writing audio file to GridFS:', err);
      mongoose.connection.close();
    });
  } catch (err) {
    console.error('Error inserting record:', err);
    mongoose.connection.close();
  }
};

// 서버 시작
app.listen(3000, () => {
  console.log('Server started on port 3000');
});
