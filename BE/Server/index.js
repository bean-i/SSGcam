require('dotenv').config();
const express = require('express');
const axios = require('axios');
const app = express()
const port = 3000

const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');

const { User } = require('./models/User');
const { FraudCases } = require('./models/FraudCases');
const { VirtualNumber } = require('./models/VirtualNumber');
const { ChatBot } = require('./models/ChatBot');

const config = require('./config/key');
const { auth } = require('./middleware/auth');

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(cookieParser());

const mongoose = require('mongoose')
const { createModel } = require('mongoose-gridfs');

mongoose.connect(config.mongoURI, {
}).then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err))

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.post('/register', (req, res) => {
    const { user_pw, user_pw_confirm } = req.body;

    if (user_pw !== user_pw_confirm) {
        return res.status(400).json({
            success: false,
            message: "비밀번호가 일치하지 않습니다."
        });
    }
    const user = new User(req.body);

    user.save().then(() => {
        res.status(200).json({
            success: true
        });
    }).catch((err) => {
        return res.status(500).json({ success: false, err });
    });
});


app.post('/api/users/login', (req, res) => {
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

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})

const voiceRecordRouter = require('./routes/voiceRecordRoutes');
app.use('/voiceRecord', voiceRecordRouter);

const recordRoutes = require('./routes/recordRoutes');
app.use('/api', recordRoutes);