const express = require('express');
const router = express.Router();
// const Record = require('../models/Record'); // Record 모델 불러오기

// /search 엔드포인트 정의
router.post('/search', async (req, res) => {
  const { phone } = req.body;

  try {
    // 전화번호로 데이터베이스에서 검색
    const records = await Record.find({ rc_fd_num: phone }, { rc_fd_num: 1, rc_fd_category: 1 });

    // 결과가 없으면 빈 배열 반환
    if (records.length === 0) {
      return res.status(200).json({ results: [] });
    }

    // 결과 반환
    res.status(200).json({ results: records });
  } catch (error) {
    console.error('Error searching phone number:', error);
    res.status(500).json({ message: 'Server Error', error });
  }
});

module.exports = router;
