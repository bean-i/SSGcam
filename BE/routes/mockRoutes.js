const express = require('express');
const router = express.Router();
const mockData = [
  {
    rc_fd_num: '01012345678',
    rc_fd_category: '대출사기형'
  },
  {
    rc_fd_num: '01087654321',
    rc_fd_category: '수사기관사칭형'
  }
];

// /search 엔드포인트 정의
router.post('/mock', (req, res) => {
  const { phone } = req.body;

  // Mock 데이터에서 전화번호 검색
  const records = mockData.filter(record => record.rc_fd_num === phone);

  // 결과가 없으면 빈 배열 반환
  if (records.length === 0) {
    return res.status(200).json({ results: [] });
  }

  // 결과 반환
  res.status(200).json({ results: records });
});

module.exports = router;
