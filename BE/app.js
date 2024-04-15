const express = require('express');
const { twiml: { VoiceResponse } } = require('twilio');
const twilio = require('twilio');
const app = express();
const PORT = 3000;

// Twilio 계정 정보 Test임
const accountSid = 'AC9726e0211620c8c577ce04e371b777cd'; // 여기에 Twilio 계정 SID 입력
const authToken = 'a3e85fbf5562a5a56de8a02eb73ad448'; // 여기에 Twilio Auth 토큰 입력
const client = new twilio(accountSid, authToken);

app.use(express.urlencoded({ extended: true }));

// 수신 전화 처리 경로
app.post('/voice', (req, res) => {
    const twiml = new VoiceResponse();
    twiml.say({ voice: 'alice' }, 'Hello, thank you for calling!');

    console.log('Incoming call received');
    console.log('From:', req.body.From); // 호출자 번호 출력
    console.log('To:', req.body.To); // 수신 번호 출력

    res.type('text/xml');
    res.send(twiml.toString());
});

// 발신 전화 초기화 경로
app.get('/make-call', (req, res) => {
    const toNumber = '+821088420603'; // 전화를 걸 대상 번호
    const fromNumber = '+12566241856'; // 구입한 Twilio 번호

    client.calls.create({
        to: toNumber,
        from: fromNumber,
        url: 'https://97f6-115-91-214-4.ngrok-free.app/voice'  // TwiML 응답을 제공하는 서버 URL
    })
    .then(call => {
        console.log('Outgoing call made!');
        console.log('To:', toNumber); // 발신 대상 번호
        console.log('From:', fromNumber); // 발신 번호
        console.log('Call SID:', call.sid); // 트랜잭션을 위한 고유 ID
        res.send(`Calling to ${toNumber}... Call SID: ${call.sid}`);
    })
    .catch(err => {
        console.error(err);
        res.status(500).send(err.message);
    });
});

// 서버 실행
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
