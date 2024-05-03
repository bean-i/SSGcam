const express = require('express');
const { client } = require('../config/twilioConfig').twilio;
const router = express.Router();

router.get('/makeCall', (req, res) => {
    const toNumber = '+821088420603';
    const fromNumber = process.env.TWILIO_PHONE_NUMBER;

    client.calls.create({
        to: toNumber,
        from: fromNumber,
        // url: 'https://97f6-115-91-214-4.ngrok-free.app/incomingCall',
        url: 'https://handler.twilio.com/twiml/EHa0aa9b3f03d72b22dbb5d3cfa96eb112', //twiml bin 사용
        record: true
    }).then(call => {
        console.log(`Calling to ${toNumber}... Call SID: ${call.sid}`);
        res.send(`Calling to ${toNumber}... Call SID: ${call.sid}`);
    }).catch(err => {
        console.error(err);
        res.status(500).send(err.message);
    });
});

module.exports = router;