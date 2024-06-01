// const express = require('express');
// const { FraudCases } = require('../models/FraudCases');
// const Counter = require('../models/Counter'); // 고유 식별자 카운터 스키마

// const router = express.Router();

// async function getNextSequence(name) {
//   const result = await Counter.findOneAndUpdate(
//     { _id: name },
//     { $inc: { seq: 1 } },
//     { new: true, upsert: true }
//   );
//   return result.seq;
// }

// router.post('/fraudcases', async (req, res) => {
//   console.log("피해사례 등록 시도");
//   try {
//     const { fc_user, fc_number, fc_description, fc_date } = req.body;

//     // 중복확인
//     const existingCase = await FraudCases.findOne({
//       fc_number: fc_number,
//       fc_user: fc_user,
//       fc_date: fc_date
//     });
//     if (existingCase) {
//       console.log("이미 등록된 피해 사례");
//       return res.status(409).send({ message: "이미 등록된 피해사례입니다." });
//     }

//     // 고유 식별자
//     fc_id = await getNextSequence('fraudcases');
//     const newFraudCase = new FraudCases({
//       fc_id,
//       fc_user,
//       fc_number,
//       fc_description,
//       fc_date,
//     });

//     await newFraudCase.save();
//     console.log("피해사례 등록 성공");
//     res.status(201).send({ message: '피해 사례가 성공적으로 등록되었습니다.', data: newFraudCase });
//   } catch (error) {
//     console.log("피해사례 등록 실패: " + error);
//     res.status(500).send({ message: '서버 오류로 피해 사례를 등록할 수 없습니다.', error: error.message });
//   }
// });

// module.exports = router;
