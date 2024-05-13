// Download the helper library from https://www.twilio.com/docs/node/install
// Find your Account SID and Auth Token at twilio.com/console
// and set the environment variables. See http://twil.io/secure
const accountSid = "AC66476925e9d263e6fad88a8a45b293dd";
const authToken = "52b7a520bd9bb93e0d404ade26d0fd1e";
const client = require('twilio')(accountSid, authToken);

client.calls
      .create({
         twiml: '<Response><Say>안녕!</Say></Response>',
         to: '+821035107029',
         from: '+15093687091'
       })
      .then(call => console.log(call.sid));
