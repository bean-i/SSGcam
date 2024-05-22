const express = require('express');
const axios = require('axios');
const router = express.Router();
require('dotenv').config();

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

router.post('/chatbot', async (req, res) => {
  const userMessage = req.body.message;
  console.log('Received message:', userMessage);

  let attempts = 0;
  const maxAttempts = 3;
  const retryDelay = 1000; // 1초

  while (attempts < maxAttempts) {
    try {
      const response = await axios.post(
        'https://api.openai.com/v1/chat/completions',
        {
          model: 'gpt-3.5-turbo',
          messages: [
            { role: 'system', content: 'You are an expert in voice phishing prevention who knows South Korean laws and regulations well. Please provide concise but detailed and accurate information.' },
            { role: 'user', content: userMessage }
          ],
          max_tokens: 500, // Increase the max_tokens to allow longer responses
          n: 1,
          stop: ["\n"],
          temperature: 0.5,
        },
        {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
          },
        }
      );

      console.log('OpenAI response:', response.data);
      return res.json({ reply: response.data.choices[0].message.content.trim() });
    } catch (error) {
      if (error.response && error.response.status === 429) {
        attempts += 1;
        console.error('Too many requests, retrying in', retryDelay, 'ms');
        await wait(retryDelay);
      } else {
        console.error('Error fetching response from OpenAI:', error);
        return res.status(500).json({ error: 'Failed to fetch response from ChatGPT' });
      }
    }
  }

  res.status(500).json({ error: 'Exceeded maximum retry attempts' });
});

module.exports = router;