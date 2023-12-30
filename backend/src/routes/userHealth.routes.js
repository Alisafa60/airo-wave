const express = require('express');
const router = express.Router();
const {addUserHealth} = require('../controllers/healthControllers/userHealth.controllers');

router.post('/health', addUserHealth);

module.exports = router;