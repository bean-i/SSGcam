const express = require('express');
const bodyParser = require('body-parser');
const incomingCallRoutes = require('./routes/incomingCallRoutes');
const makeCallRoutes = require('./routes/makeCallRoutes');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(incomingCallRoutes);
app.use(makeCallRoutes);

module.exports = app;