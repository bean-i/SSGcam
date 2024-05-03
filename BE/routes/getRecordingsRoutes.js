const express = require('express');
const router = express.Router();
const { client } = require('../config/twilioConfig').twilio;

router.get('/getRecordings', (req, res) => {
    client.recordings.list({limit: 20})
    .then(recordings => {
        if (recordings.length === 0) {
            console.log('No recordings found.');
            res.status(404).send('No recordings found.');
            return;
        }
        recordings.forEach(r => console.log(r.sid));
        res.send(recordings.map(r => ({
            sid: r.sid,
            url: `https://api.twilio.com/2010-04-01/Accounts/${process.env.TWILIO_ACCOUNT_SID}/Recordings/${r.sid}.mp3`
        })));
    })
    .catch(err => {
        console.error(err);
        res.status(500).send(err.message);
    });

});

module.exports = router;
