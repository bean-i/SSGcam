const express = require('express');
const WebSocket = require('ws');
const app = express();
const server = require('http').createServer(app);
const wss = new WebSocket.Server({  server });

wss.on('connection', function connection(ws) {
    console.log('received');
    ws.on('message', function incoming(message) {
        console.log('received: %s',message);
        // 음성 데이터 처리 및 분석
    });

    ws.send('something');
});

wss.on('listening', () => {
    console.log('Server is listening on port 3000');
  });
  
wss.on('error', (error) => {
console.error('WebSocket server error:', error);
});

server.listen(3000, () => {
    console.log(`HTTP 및 WebSocket 서버가 포트 ${3000}에서 실행 중입니다.`);
});

var socket = new WebSocket('wss://3d0f-175-192-51-218.ngrok-free.app');

socket.onopen = function(event) {
    console.log('Connected to the server');
    // 서버에 메시지 전송
    socket.send('Hello, server!');
};

socket.onmessage = function(event) {
    console.log('Message from server ', event.data);
};

socket.onerror = function(error) {
    console.error('WebSocket error:', error.message);
};