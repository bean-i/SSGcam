app.post('/handle-full-recording', async (req, res) => {
//   const recordingSid = req.body.RecordingSid; // 녹음 파일의 SID를 가져옵니다
//   console.log(`Full Recording SID: ${recordingSid}`);
//   const recordingUrl = req.body.RecordingUrl + '.wav'; // 녹음 파일의 URL을 가져옵니다

//   // 고유한 파일명 생성
//   const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
//   const filename = `full_${timestamp}.wav`;

//   try {
//     await downloadRecording(recordingUrl, filename);
//     console.log(`전체 녹음 파일이 성공적으로 저장되었습니다: ${filename}`);
//     res.type('text/xml');
//     res.status(200).send('<Response><Say language="ko-KR" voice="Polly.Seoyeon">전체 녹음 파일이 성공적으로 저장되었습니다. 감사합니다!</Say></Response>');
//   } catch (error) {
//     console.error('전체 녹음 파일 다운로드 중 오류 발생:', error);
//     res.status(500).send('전체 녹음 파일 다운로드 중 오류가 발생했습니다.');
//   }
// });