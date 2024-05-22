app.post('/fraudcases', async (req, res) => {
//   try {
//     const { fc_user, fc_number, fc_description, fc_date } = req.body;

//     const newFraudCase = new FraudCases({
//       fc_user,
//       fc_number,
//       fc_description,
//       fc_date: fc_date ? new Date(fc_date) : undefined, 
//     });

//     await newFraudCase.save();

//     res.status(201).send({ message: '피해 사례가 성공적으로 등록되었습니다.', data: newFraudCase });
//   } catch (error) {
//     res.status(500).send({ message: '서버 오류로 피해 사례를 등록할 수 없습니다.', error: error.message });
//   }
// });