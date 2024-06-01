require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const app = require('./app'); // app.js에서 설정한 라우트를 불러옴
const config = require('./config/key');

const port = 3000;

mongoose.connect(config.mongoURI, {})
  .then(() => console.log('MongoDB Connected...'))
  .catch(err => console.log(err));

const server = express();

server.use('/', app);

server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
