const express = require('express');
const router = express.Router();
const twilio = require('twilio');

router.post('/voice', (req, res) => {
    const response = new twilio.twiml.VoiceResponse();
    response.start().stream({ url: 'wss://3ccbda9d7ed4.ngrok.app' });
    response.say('Hi bin, Start speaking to see your audio transcribed in the console');
    response.pause({ length: 30 });

    res.set('Content-Type', 'text/xml');
    res.send(response.toString());
});

module.exports = router;
