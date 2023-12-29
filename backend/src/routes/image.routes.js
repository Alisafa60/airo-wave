const express = require('express');
const router = express.Router();
const {authMiddleware} = require('../middlewares/auth.middleware');
const { uploadProfilePicture, deleteProfilePicture } = require('../controllers/image.controllers');
const upload = require('../utils/imageUpload');

router.post('/users/:userId/profile-picture', authMiddleware, upload.single('profilePicture'), uploadProfilePicture);
router.delete('/users/:userId/profile-picture', authMiddleware, deleteProfilePicture);

module.exports = router;