const express = require('express');
const { User } = require('../models/User');
const { auth } = require('../middleware/auth');

const router = express.Router();

router.post('/register', (req, res) => {
  const { name, username, password, confirmPassword, parentContact } = req.body;
  console.log('회원가입 요청 데이터:', req.body);

  if (password !== confirmPassword) {
    console.log('비밀번호가 일치하지 않습니다.');
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
    user_pt_num: parentContact
  });

  user.save()
    .then(() => {
      console.log('회원가입 성공');
      res.status(200).json({
        success: true
      });
    }).catch((err) => {
      console.log('회원가입 실패 : ', err);
      return res.status(500).json({ success: false, err });
    });
});

router.post('/login', (req, res) => {
  console.log('로그인 시도');
  User.findOne({ user_id: req.body.user_id })
    .then(async (user) => {
      if (!user) {
        throw new Error("제공된 아이디에 해당하는 유저가 없습니다.");
      }
      const isMatch = await user.comparePassword(req.body.user_pw);
      return { isMatch, user };
    })
    .then(({ isMatch, user }) => {
      console.log(isMatch);
      if (!isMatch) {
        throw new Error("비밀번호가 틀렸습니다.");
      }
      const token = user.generateToken();
      console.log("생성된 JWT:", token);
      res.status(200).json({
        loginSuccess: true,
        token: token,
        userId: user._id
      });
    })
    .catch((err) => {
      console.log(err);
      return res.status(400).json({
        loginSuccess: false,
        message: err.message
      });
    });
});

router.get('/auth', auth, (req, res) => {
  res.status(200).json({
    _id: req.user._id,
    isAdmin: req.user.role === 0 ? false : true,
    isAuth: true,
    user_name: req.user.user_name,
    user_pt_num: req.user.user_pt_num,
    role: req.user.role
  });
});

router.get('/logout', auth, async (req, res) => {
  try {
    await User.findOneAndUpdate({ _id: req.user._id }, { token: "" });
    return res.status(200).send({ success: true });
  } catch (err) {
    return res.json({ success: false, err });
  }
});

module.exports = router;
