const express = require('express');
const bodyParser = require('body-parser');
const incomingCallRoutes = require('./routes/incomingCallRoutes');
const makeCallRoutes = require('./routes/makeCallRoutes');
const getRecordingsRoutes = require('./routes/getRecordingsRoutes');
const chatbotRoutes = require('./routes/chatbotRoutes');
const searchRoutes = require('./routes/searchRoutes');
const mockRoutes = require('./routes/mockRoutes');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(incomingCallRoutes);
app.use(makeCallRoutes);
app.use(getRecordingsRoutes);
app.use(chatbotRoutes);
app.use(searchRoutes);
app.use(mockRoutes);

module.exports = app;
