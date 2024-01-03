const express = require('express');
const router = express.Router();
const chatbot = require('../controllers/chatbotControllers/chatbot.controllers')

router.post('/chatbotMessage', chatbot.createMessage);
router.post('/chatbotResponse', chatbot.createResponse);
router.get('/chatbotMessage/:id', chatbot.getMessagesByConversationId);

module.exports = router;