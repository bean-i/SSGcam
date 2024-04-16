const express = require('express');
const { twiml: { VoiceResponse } } = require('twilio');
const router = express.Router();

router.post('/incomingCall', (req, res) => {
    const twiml = new VoiceResponse();
    twiml.say({ voice: 'alice' }, 'Hello, thank you for calling!');

    console.log('Incoming call received');
    console.log('From:', req.body.From);
    console.log('To:', req.body.To);

    res.type('text/xml');
    console.log(twiml.toString());
    res.send(twiml.toString());
});

module.exports = router;