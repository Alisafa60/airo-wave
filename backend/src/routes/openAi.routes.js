const express = require('express');
const router = express.Router();
const openaiController = require('../controllers/chatbotControllers/chatbot');

router.post('/medcat/message', openaiController.generateOpenAIPayload);

module.exports = router;