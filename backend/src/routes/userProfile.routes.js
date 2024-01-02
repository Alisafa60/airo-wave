const express = require('express');
const router = express.Router();
const profile = require('../controllers/userProfile/userProfile.controllers');

router.put('/user/profile', profile.updateProfile);
router.put('/user/password', profile.changePassword);
router.get('/user/profile', profile.getUserProfile);

module.exports = router;