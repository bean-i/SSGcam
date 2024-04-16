const express = require('express');
const { client } = require('../config/twilioConfig').twilio;
const router = express.Router();

router.get('/makeCall', (req, res) => {
    const toNumber = '+821088420603';
    const fromNumber = process.env.TWILIO_PHONE_NUMBER;

    client.calls.create({
        to: toNumber,
        from: fromNumber,
        url: 'https://97f6-115-91-214-4.ngrok-free.app/incomingCall' // 수정된 URL에 맞게 변경하세요.
    })
    .then(call => {
        console.log('Outgoing call made!');
        console.log('To:', toNumber);
        console.log('From:', fromNumber);
        console.log('Call SID:', call.sid);
        res.send(`Calling to ${toNumber}... Call SID: ${call.sid}`);
    })
    .catch(err => {
        console.error(err);
        res.status(500).send(err.message);
    });
});

module.exports = router;