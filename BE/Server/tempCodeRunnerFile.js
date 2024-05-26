require('dotenv').config();
const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const { GridFSBucket } = require('mongodb');

const { User } = require('./models/User');
const config = require('./config/key');
const { auth } = require('./middleware/auth');
const { FraudCases } = require('./models/FraudCases');
const { VirtualNumber } = require('./models/VirtualNumber');
const { ChatBot } = require('./models/ChatBot');

const twilio = require('twilio');
// const accountSid = '';
// const authToken = '';
// const client = twilio(accountSid, authToken);

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(cookieParser());

const mongoose = require('mongoose')
// const { createModel } = require('mongoose-gridfs');
const Grid = require('gridfs-stream');
const { Schema } = mongoose;

mongoose.connect(config.mongoURI, {
}).then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err))

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.post('/register', (req, res) => {
  const { name, username, password, confirmPassword, parentContact } = req.body;
  console.log('Register endpoint hit with:', req.body);

  if (password !== confirmPassword) {
    console.log('비번 확인 잘못됨');
      return res.status(400).json({
          success: false,
          message: "비밀번호가 일치하지 않습니다."
      });
  }
  const user = new User({
    user_name: name,
    user_id: username,
    user_pw: password,
    user_pw_confirm: confirmPassword,
    user_pt_num: parentContact,
  });

  user.save()
    .then(() => {
      console.log('저장 성공');
      res.status(200).json({
          success: true
      });
  }).catch((err) => {
      console.log('저장 실패 : ', err);
      return res.status(500).json({ success: false, err });
  });
});


app.post('/api/users/login', (req, res) => {
  console.log('로그인 시도');
  User.findOne({
    user_id: req.body.user_id
  })
  .then (async (user) => {
      if (!user) {
          throw new Error("제공된 아이디에 해당하는 유저가 없습니다.")
      }
      const isMatch = await user.comparePassword(req.body.user_pw);
      return { isMatch, user };
  })
  .then(({ isMatch, user }) => {
      console.log(isMatch);
      if (!isMatch) {
          throw new Error("비밀번호가 틀렸습니다.")
      }
      return user.generateToken();
  })
  .then ((user) => {
      return res.cookie("x_auth", user.token)
      .status(200)
      .json({
          loginSuccess: true,
          userId: user._id
      });
  })
  .catch ((err) => {
      console.log(err);
      return res.status(400).json({
          loginSuccess: false,
          message: err.message
      });
  })
});

app.get('/api/users/auth', auth, (req, res) => {
  res.status(200).json({
      _id : req.user._id,
      isAdmin : req.user.role === 0 ? false : true,
      isAuth: true,
      user_name : req.user.user_name,
      user_pt_num: req.user.user_pt_num,
      role : req.user.role,
  })
})

app.get('/api/users/logout', auth, async (req, res) =>{
  try {
      await User.findOneAndUpdate({ _id: req.user._id }, { token: "" });
      return res.status(200).send({ success: true });
  } catch (err) {
      return res.json({ success: false, err });
  }
});




// Record 데이터 가져오기
const Record = require('./models/Record');
const conn = mongoose.connection;
let gfsBucket;
// conn.once('open', () => {
//   gfs = Grid(conn.db, mongoose.mongo);
//   gfs.collection('uploads');
//   console.log('GridFS initialized');
// });
conn.once('open', () => {
  gfsBucket = new GridFSBucket(conn.db, { bucketName: 'uploads' });
  console.log('GridFSBucket initialized');
});

app.get('/api/records', async (req, res) => {
  console.log('탐지기록 가져오기 시도');
  try{
    const records = await Record.find();
    console.log('탐지기록 가져오기 성공');
    res.status(200).json(records);
  }catch (err) {
    console.log('탐지기록 가져오기 실패: ',err.message);
    res.status(500).json({ sucess: false, error: err.message });
  }
});
app.get('/api/audio/:id', async (req, res) => {
  console.log("오디오 파일 요청 수신, ID:", req.params.id);
  try {
    const file = await conn.db.collection('uploads.files').findOne({ _id: new mongoose.Types.ObjectId(req.params.id) });
    if (!file) {
      console.log("파일을 찾을 수 없음");
      return res.status(404).json({ success: false, message: '파일을 찾을 수 없습니다.' });
    }

    console.log("파일 찾음:", file);
    res.set('Content-Type', file.contentType);

    const readstream = gfsBucket.openDownloadStream(file._id);

    readstream.on('data', (chunk) => {
      console.log('데이터 청크 수신:', chunk.length);
    });

    readstream.on('end', () => {
      console.log('파일 스트리밍 완료');
    });

    readstream.on('error', (err) => {
      console.error('스트리밍 중 오류 발생:', err);
      res.status(500).json({ success: false, error: err.message });
    });

    readstream.pipe(res);
  } catch (err) {
    console.log('오디오 파일 가져오기 실패:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})