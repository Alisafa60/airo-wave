const express = require('express');
const router = express.Router();
const { chatBotController, getLastResponse } = require('../controllers/chatbotControllers/openAi.controller');

router.post('/medcat/message', chatBotController);
router.get('/medcat/message', getLastResponse);

module.exports = router;