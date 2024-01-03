const express = require('express');
const router = express.Router();
const contactProfessional = require('../controllers/healthProfessionalControllers/contactProfessional.controllers');

router.post('/contactProfessional', contactProfessional.createContactProfessional);
router.post('/messages/reply', contactProfessional.createReply);
router.get('/messages/sender', contactProfessional.getMessagesForSender);
router.get('/messages/recipient', contactProfessional.getMessagesForRecipient);

module.exports = router;