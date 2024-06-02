const express = require('express');
const bodyParser = require('body-parser');
const chatbotRoutes = require('./routes/chatbotRoutes');
const searchRoutes = require('./routes/searchRoutes');
const app = express();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

app.use(chatbotRoutes);
app.use(searchRoutes);

module.exports = app;
