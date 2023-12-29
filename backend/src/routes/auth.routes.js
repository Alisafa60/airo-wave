const express = require('express');
const { register, login } = require('../controllers/authControllers/auth.controllers');
const router = express.Router();

router.post('/register', register);
router.post('/login', login);

module.exports = router;