const express = require('express');
const { twiml: { VoiceResponse } } = require('twilio');

const router = express.Router();

router.post('/voice', (req, res) => {
    const twiml = new VoiceResponse();
    twiml.say({ voice: 'alice', language: 'ko-KR' }, '잠시 후 연결됩니다.');
    
    // const dial = twiml.dial({callerId: process.env.TWILIO_PHONE_NUMBER});
    // dial.number('+821088420603');

    console.log('Incoming call received');
    console.log('From:', req.body.From);
    console.log('To:', req.body.To);

    res.type('text/xml');
    res.send(twiml.toString());
});

module.exports = router;