const express = require('express');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');

const chatbotRoutes = require('./routes/chatbotRoutes');
const fraudCaseRoutes = require('./routes/fraudCaseRoutes');
const recordRoutes = require('./routes/recordRoutes');
const searchRoutes = require('./routes/searchRoutes');
const userRoutes = require('./routes/userRoutes');
const voiceRecordRoutes = require('./routes/voiceRecordRoutes');

const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cookieParser());

app.use('/api/chatbot', chatbotRoutes);
app.use('/api/fraudcases', fraudCaseRoutes);
app.use('/api/records', recordRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/users', userRoutes);
app.use('/api/voice', voiceRecordRoutes);

module.exports = app;
