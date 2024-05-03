const express = require('express');
const { client } = require('../config/twilioConfig').twilio;
const router = express.Router();

router.get('/returnCall', (req, res) => {
    const fromNumber = '+13203481704';
    const toNumber = process.env.TWILIO_PHONE_NUMBER;

    client.calls.create({
        to: toNumber,
        from: fromNumber,
        url: 'https://97f6-115-91-214-4.ngrok-free.app/incomingCall',
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